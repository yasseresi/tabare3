-- Notify accepted donors when a recipient edits their open request.
--
-- update_blood_request let a recipient change the hospital, blood type,
-- urgency, units, or deadline of an open request, but donors who had already
-- accepted (an active appointment) were never told — they could show up on
-- stale details. The RPC now emits a `request_update` notification to every
-- pending/confirmed appointment on the request. Everything else is unchanged
-- from 20260730104121_secure_donation_workflows.sql.

create or replace function public.update_blood_request(
  p_request_id uuid,
  p_hospital_id uuid,
  p_blood_type public.blood_type_enum,
  p_urgency public.request_urgency_enum,
  p_units_needed integer,
  p_needed_by timestamptz,
  p_notes text
)
returns public.blood_requests
language plpgsql
security definer
set search_path = pg_catalog, public, extensions
as $$
declare
  v_caller uuid := auth.uid();
  v_hospital public.hospitals;
  v_wilaya_name text;
  v_request public.blood_requests;
begin
  if v_caller is null then
    raise exception using errcode = 'P0001', message = 'unauthenticated';
  end if;

  if p_units_needed is null or p_units_needed <= 0 then
    raise exception using errcode = '22023', message = 'invalid_units_needed';
  end if;

  if p_needed_by is not null and p_needed_by <= now() then
    raise exception using errcode = '22023', message = 'needed_by_must_be_future';
  end if;

  select *
  into v_hospital
  from public.hospitals h
  where h.id = p_hospital_id and h.is_active;

  if not found then
    raise exception using errcode = 'P0001', message = 'hospital_not_found';
  end if;

  select name_ar
  into v_wilaya_name
  from public.wilayas
  where id = v_hospital.wilaya_id;

  update public.blood_requests r
  set
    hospital_name = v_hospital.name_ar,
    hospital_id = v_hospital.id,
    city = v_wilaya_name,
    wilaya_id = v_hospital.wilaya_id,
    blood_type = p_blood_type,
    urgency = p_urgency,
    units_needed = p_units_needed,
    needed_by = p_needed_by,
    notes = nullif(btrim(p_notes), ''),
    expires_at = coalesce(p_needed_by, r.expires_at)
  where r.id = p_request_id
    and r.requested_by = v_caller
    and r.status = 'open'
    and r.deleted_at is null
    and r.units_fulfilled = 0
  returning * into v_request;

  if not found then
    raise exception using errcode = 'P0001', message = 'request_not_editable';
  end if;

  -- Tell every donor who already accepted this request that its details moved.
  insert into public.notifications (
    user_id,
    type,
    title,
    body,
    ref_id,
    ref_type
  )
  select
    a.donor_id,
    'request_update',
    'تم تحديث الطلب',
    'قام صاحب الطلب بتحديث تفاصيل طلب التبرع الذي وافقت عليه.',
    v_request.id,
    'blood_request'
  from public.appointments a
  where a.blood_request_id = v_request.id
    and a.status in ('pending', 'confirmed')
    and a.deleted_at is null;

  return v_request;
end;
$$;
