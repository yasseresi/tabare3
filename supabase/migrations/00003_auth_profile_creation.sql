-- ============================================================
-- تبرع (Tabara3) — Auth Profile Creation Migration
-- Creates handle_new_user() trigger on auth.users to populate
-- public.users from raw_user_meta_data passed during signUp().
-- Also adds missing columns for Figma signup fields.
-- ============================================================

-- ============================================================
-- 1. ADD MISSING COLUMNS (Figma signup fields not in schema)
-- ============================================================
alter table public.users
  add column if not exists national_id      text,
  add column if not exists weight           numeric(5,2),
  add column if not exists chronic_diseases text;

comment on column public.users.national_id      is 'National ID card number (بطاقة التعريف الوطنية) — collected at signup step 2';
comment on column public.users.weight           is 'Body weight in kg — collected at signup step 2';
comment on column public.users.chronic_diseases is 'Chronic medical conditions (الأمراض المزمنة) — free text, collected at signup step 2';


-- ============================================================
-- 2. RELAX at_least_one_role CONSTRAINT
-- Roles (is_donor / is_recipient) are selected AFTER signup
-- via the role selection screen. Both start false; the
-- constraint is enforced at the application level instead.
-- ============================================================
alter table public.users
  drop constraint if exists at_least_one_role;


-- ============================================================
-- 3. HANDLE_NEW_USER TRIGGER FUNCTION
-- Fires AFTER INSERT on auth.users. Reads raw_user_meta_data
-- (passed by the client during supabase.auth.signUp()) and
-- inserts the corresponding row into public.users.
--
-- Required metadata keys (client MUST pass during signUp):
--   username, full_name, date_of_birth, gender,
--   phone, blood_type, city
--
-- Optional metadata keys:
--   national_id, weight, chronic_diseases
--
-- email is sourced from auth.users.email directly.
-- ============================================================
create or replace function public.handle_new_user()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
declare
  v_username        text;
  v_full_name       text;
  v_date_of_birth   date;
  v_gender          text;
  v_phone           text;
  v_blood_type      blood_type_enum;
  v_city            text;
  v_national_id     text;
  v_weight          numeric(5,2);
  v_chronic_diseases text;
begin
  v_username         := new.raw_user_meta_data->>'username';
  v_full_name        := new.raw_user_meta_data->>'full_name';
  v_date_of_birth    := (new.raw_user_meta_data->>'date_of_birth')::date;
  v_gender           := new.raw_user_meta_data->>'gender';
  v_phone            := new.raw_user_meta_data->>'phone';
  v_blood_type       := (new.raw_user_meta_data->>'blood_type')::blood_type_enum;
  v_city             := new.raw_user_meta_data->>'city';
  v_national_id      := new.raw_user_meta_data->>'national_id';
  v_weight           := nullif(new.raw_user_meta_data->>'weight', '')::numeric(5,2);
  v_chronic_diseases := new.raw_user_meta_data->>'chronic_diseases';

  if v_username is null then
    raise exception 'Missing required metadata: username';
  end if;
  if v_full_name is null then
    raise exception 'Missing required metadata: full_name';
  end if;
  if v_date_of_birth is null then
    raise exception 'Missing required metadata: date_of_birth';
  end if;
  if v_gender is null or (v_gender not in ('male', 'female')) then
    raise exception 'Missing or invalid metadata: gender (must be male or female)';
  end if;
  if v_phone is null then
    raise exception 'Missing required metadata: phone';
  end if;
  if v_blood_type is null then
    raise exception 'Missing required metadata: blood_type';
  end if;
  if v_city is null then
    raise exception 'Missing required metadata: city';
  end if;

  insert into public.users (
    id,
    username,
    full_name,
    date_of_birth,
    gender,
    phone,
    email,
    blood_type,
    city,
    national_id,
    weight,
    chronic_diseases
  )
  values (
    new.id,
    v_username,
    v_full_name,
    v_date_of_birth,
    v_gender,
    v_phone,
    new.email,
    v_blood_type,
    v_city,
    v_national_id,
    v_weight,
    v_chronic_diseases
  );

  return new;
end;
$$;


-- ============================================================
-- 4. TRIGGER: on_auth_user_created
-- Fires handle_new_user() after a new auth user is created.
-- ============================================================
drop trigger if exists on_auth_user_created on auth.users;
create trigger on_auth_user_created
  after insert on auth.users
  for each row execute function public.handle_new_user();
