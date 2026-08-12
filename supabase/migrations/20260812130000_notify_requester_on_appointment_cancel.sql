-- Notify the recipient when a donor cancels their appointment.
--
-- cancel_appointment let a donor back out of a confirmed donation, but the
-- recipient who was counting on them was never told and could not chase a
-- replacement. The RPC now writes a notification to the request owner.
-- Everything else is unchanged from 20260730104121_secure_donation_workflows.sql.

create or replace function public.cancel_appointment(
  p_appointment_id uuid,
  p_reason text
)
returns public.appointments
language plpgsql
security definer
set search_path = pg_catalog, public, extensions
as $$
declare
  v_caller uuid := auth.uid();
  v_appointment public.appointments;
begin
  if v_caller is null then
    raise exception using errcode = 'P0001', message = 'unauthenticated';
  end if;

  if nullif(btrim(p_reason), '') is null then
    raise exception using errcode = '22023', message = 'cancel_reason_required';
  end if;

  update public.appointments a
  set
    status = 'cancelled',
    cancelled_at = now(),
    cancel_reason = btrim(p_reason)
  where a.id = p_appointment_id
    and (a.donor_id = v_caller or public.is_admin())
    and a.status in ('pending', 'confirmed')
    and a.deleted_at is null
  returning * into v_appointment;

  if not found then
    raise exception using errcode = 'P0001', message = 'appointment_not_cancellable';
  end if;

  -- Tell the recipient their donor pulled out so they can find a replacement.
  insert into public.notifications (
    user_id,
    type,
    title,
    body,
    ref_id,
    ref_type
  )
  select
    r.requested_by,
    'request_update',
    'ألغى متبرع موعده',
    'اعتذر أحد المتبرعين عن موعد التبرع الخاص بطلبك.',
    r.id,
    'blood_request'
  from public.blood_requests r
  where r.id = v_appointment.blood_request_id
    and r.requested_by is not null;

  return v_appointment;
end;
$$;
