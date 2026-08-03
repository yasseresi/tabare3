-- The donor request cards show the patient the blood is for. `request_patients`
-- already stores that snapshot for both `self` and `other` beneficiaries, so
-- expose it through the compatible-request feed.
drop function if exists public.compatible_requests_for_donor();

create function public.compatible_requests_for_donor()
returns table (
  id uuid,
  requested_by uuid,
  patient_name text,
  blood_type public.blood_type_enum,
  urgency public.request_urgency_enum,
  units_needed integer,
  units_fulfilled integer,
  status public.request_status_enum,
  needed_by timestamptz,
  expires_at timestamptz,
  notes text,
  created_at timestamptz,
  hospital jsonb
)
language plpgsql
stable
security definer
set search_path = pg_catalog, public, extensions
as $$
declare
  v_caller uuid := auth.uid();
begin
  if v_caller is null then
    raise exception using errcode = 'P0001', message = 'unauthenticated';
  end if;

  if not exists (
    select 1
    from public.users u
    where u.id = v_caller
      and u.deleted_at is null
      and u.is_active
      and u.is_donor
      and u.is_available_for_donation
      and u.date_of_birth <= current_date - interval '18 years'
      and (u.cooldown_until is null or u.cooldown_until <= current_date)
      and not exists (
        select 1
        from public.user_chronic_diseases ucd
        join public.chronic_diseases cd on cd.id = ucd.disease_id
        where ucd.user_id = u.id
          and cd.is_active
          and cd.blocks_donation
      )
      and not exists (
        select 1
        from public.appointments a
        where a.donor_id = u.id
          and a.status in ('pending', 'confirmed')
          and a.deleted_at is null
      )
  ) then
    return;
  end if;

  return query
  select
    r.id,
    r.requested_by,
    coalesce(rp.full_name, ru.full_name),
    r.blood_type,
    r.urgency,
    r.units_needed,
    r.units_fulfilled,
    r.status,
    r.needed_by,
    r.expires_at,
    r.notes,
    r.created_at,
    jsonb_build_object(
      'id', h.id,
      'wilaya_id', h.wilaya_id,
      'name_ar', h.name_ar,
      'name_fr', h.name_fr,
      'address', h.address,
      'is_active', h.is_active
    )
  from public.users u
  join public.blood_type_compatibility c
    on c.donor_type = u.blood_type
  join public.blood_requests r
    on r.blood_type = c.recipient_type
   and r.wilaya_id = u.wilaya_id
  join public.hospitals h on h.id = r.hospital_id
  join public.users ru on ru.id = r.requested_by
  left join public.request_patients rp on rp.request_id = r.id
  where u.id = v_caller
    and r.requested_by <> v_caller
    and r.status = 'open'
    and r.deleted_at is null
    and h.is_active
    and (r.needed_by is null or r.needed_by > now())
    and (r.expires_at is null or r.expires_at > now())
  order by r.created_at desc;
end;
$$;

revoke all on function public.compatible_requests_for_donor() from public;
revoke all on function public.compatible_requests_for_donor() from anon;
grant execute on function public.compatible_requests_for_donor()
  to authenticated;
