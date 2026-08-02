do $$
begin
  create type public.beneficiary_type_enum as enum ('self', 'other');
exception
  when duplicate_object then null;
end;
$$;

alter table public.blood_requests
  add column if not exists beneficiary_type public.beneficiary_type_enum
    not null default 'self';

create table if not exists public.request_patients (
  request_id uuid primary key
    references public.blood_requests(id) on delete cascade,
  full_name text not null,
  national_id text not null,
  blood_type public.blood_type_enum not null,
  weight numeric not null check (weight > 0),
  chronic_diseases text,
  gender text not null,
  date_of_birth date not null,
  created_at timestamptz not null default now()
);

alter table public.request_patients enable row level security;

create policy request_patients_select_owner_or_admin
  on public.request_patients
  for select
  to authenticated
  using (
    exists (
      select 1
      from public.blood_requests r
      where r.id = request_id
        and (r.requested_by = (select auth.uid()) or public.is_admin())
    )
  );

grant select on table public.request_patients to authenticated;

drop function if exists public.create_blood_request(
  uuid,
  public.blood_type_enum,
  public.request_urgency_enum,
  integer,
  timestamptz,
  text
);

create function public.create_blood_request(
  p_hospital_id uuid,
  p_beneficiary_type public.beneficiary_type_enum,
  p_patient_full_name text,
  p_patient_national_id text,
  p_patient_blood_type public.blood_type_enum,
  p_patient_weight numeric,
  p_patient_chronic_diseases text,
  p_patient_gender text,
  p_patient_date_of_birth date,
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
  v_patient record;
begin
  if v_caller is null then
    raise exception using errcode = 'P0001', message = 'unauthenticated';
  end if;

  if not exists (
    select 1 from public.users u
    where u.id = v_caller
      and u.deleted_at is null
      and u.is_active
      and (u.is_recipient or u.active_mode = 'recipient')
  ) then
    raise exception using errcode = 'P0001', message = 'recipient_mode_required';
  end if;

  if p_units_needed is null or p_units_needed <= 0 then
    raise exception using errcode = '22023', message = 'invalid_units_needed';
  end if;

  if p_needed_by is not null and p_needed_by <= now() then
    raise exception using errcode = '22023', message = 'needed_by_must_be_future';
  end if;

  select * into v_hospital
  from public.hospitals h
  where h.id = p_hospital_id and h.is_active;
  if not found then
    raise exception using errcode = 'P0001', message = 'hospital_not_found';
  end if;

  if p_beneficiary_type = 'self' then
    select
      u.full_name,
      u.national_id,
      u.blood_type,
      u.weight,
      u.chronic_diseases,
      u.gender,
      u.date_of_birth
    into v_patient
    from public.users u
    where u.id = v_caller;
  elsif p_patient_full_name is null
    or p_patient_national_id is null
    or p_patient_blood_type is null
    or p_patient_weight is null
    or p_patient_gender is null
    or p_patient_date_of_birth is null then
    raise exception using errcode = '22023', message = 'patient_details_required';
  else
    select
      btrim(p_patient_full_name),
      btrim(p_patient_national_id),
      p_patient_blood_type,
      p_patient_weight,
      nullif(btrim(p_patient_chronic_diseases), ''),
      p_patient_gender,
      p_patient_date_of_birth
    into v_patient;
  end if;

  if v_patient.blood_type <> p_blood_type then
    raise exception using errcode = '22023', message = 'patient_blood_type_mismatch';
  end if;

  select name_ar into v_wilaya_name
  from public.wilayas where id = v_hospital.wilaya_id;

  insert into public.blood_requests (
    requested_by, hospital_name, hospital_id, city, wilaya_id,
    beneficiary_type, blood_type, urgency, units_needed, needed_by, notes,
    expires_at
  ) values (
    v_caller, v_hospital.name_ar, v_hospital.id, v_wilaya_name,
    v_hospital.wilaya_id, p_beneficiary_type, v_patient.blood_type,
    p_urgency, p_units_needed, p_needed_by, nullif(btrim(p_notes), ''),
    coalesce(p_needed_by, now() + interval '7 days')
  ) returning * into v_request;

  insert into public.request_patients (
    request_id, full_name, national_id, blood_type, weight,
    chronic_diseases, gender, date_of_birth
  ) values (
    v_request.id, v_patient.full_name, v_patient.national_id,
    v_patient.blood_type, v_patient.weight, v_patient.chronic_diseases,
    v_patient.gender, v_patient.date_of_birth
  );

  return v_request;
end;
$$;

revoke all on function public.create_blood_request(
  uuid, public.beneficiary_type_enum, text, text, public.blood_type_enum,
  numeric, text, text, date, public.blood_type_enum,
  public.request_urgency_enum, integer, timestamptz, text
) from public;
revoke all on function public.create_blood_request(
  uuid, public.beneficiary_type_enum, text, text, public.blood_type_enum,
  numeric, text, text, date, public.blood_type_enum,
  public.request_urgency_enum, integer, timestamptz, text
) from anon;
grant execute on function public.create_blood_request(
  uuid, public.beneficiary_type_enum, text, text, public.blood_type_enum,
  numeric, text, text, date, public.blood_type_enum,
  public.request_urgency_enum, integer, timestamptz, text
) to authenticated;
