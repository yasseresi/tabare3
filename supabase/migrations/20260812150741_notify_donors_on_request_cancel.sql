-- Notify accepted donors when a recipient cancels their open request.
--
-- cancel_blood_request voids every pending/confirmed appointment on the
-- request, but the affected donors were never told — they could travel to a
-- donation that no longer exists. The RPC now writes a notification for each
-- appointment it cancels. Everything else is unchanged from
-- 20260730104121_secure_donation_workflows.sql.

create or replace function public.cancel_blood_request(
  p_request_id uuid,
  p_reason text
)
returns public.blood_requests
language plpgsql
security definer
set search_path = pg_catalog, public, extensions
as $$
declare
  v_caller uuid := auth.uid();
  v_request public.blood_requests;
begin
  if v_caller is null then
    raise exception using errcode = 'P0001', message = 'unauthenticated';
  end if;

  if nullif(btrim(p_reason), '') is null then
    raise exception using errcode = '22023', message = 'cancel_reason_required';
  end if;

  update public.blood_requests r
  set
    status = 'cancelled',
    cancelled_at = now(),
    cancel_reason = btrim(p_reason)
  where r.id = p_request_id
    and (r.requested_by = v_caller or public.is_admin())
    and r.status = 'open'
    and r.deleted_at is null
  returning * into v_request;

  if not found then
    raise exception using errcode = 'P0001', message = 'request_not_cancellable';
  end if;

  -- Void the donors' appointments and notify each affected donor in one step.
  with cancelled as (
    update public.appointments
    set
      status = 'cancelled',
      cancelled_at = now(),
      cancel_reason = 'request_cancelled'
    where blood_request_id = p_request_id
      and status in ('pending', 'confirmed')
      and deleted_at is null
    returning donor_id
  )
  insert into public.notifications (
    user_id,
    type,
    title,
    body,
    ref_id,
    ref_type
  )
  select
    cancelled.donor_id,
    'request_update',
    'تم إلغاء الطلب',
    'قام صاحب الطلب بإلغاء طلب التبرع الذي وافقت عليه.',
    p_request_id,
    'blood_request'
  from cancelled;

  update public.direct_invitations
  set status = 'cancelled'
  where request_id = p_request_id and status = 'sent';

  return v_request;
end;
$$;
