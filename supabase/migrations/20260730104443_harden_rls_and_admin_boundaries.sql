-- ============================================================
-- RLS, grants, immutable identity, and admin hardening
-- ============================================================

alter function public.is_admin()
  set search_path = pg_catalog, public, extensions;
alter function public.set_updated_at()
  set search_path = pg_catalog, public, extensions;
alter function public.sync_total_points()
  set search_path = pg_catalog, public, extensions;
alter function public.on_appointment_completed()
  set search_path = pg_catalog, public, extensions;
alter function public.handle_new_user()
  set search_path = pg_catalog, public, extensions;

create or replace function public.sync_user_wilaya_id()
returns trigger
language plpgsql
set search_path = pg_catalog, public, extensions
as $$
begin
  if tg_op = 'INSERT' or new.city is distinct from old.city then
    select w.id
    into new.wilaya_id
    from public.wilayas w
    where lower(btrim(new.city)) in (
      lower(btrim(w.name_ar)),
      lower(btrim(w.name_fr))
    )
      or (
        w.id = 16
        and lower(btrim(new.city)) = 'algiers'
      )
    limit 1;

    if new.wilaya_id is null then
      raise exception using errcode = '22023', message = 'invalid_wilaya';
    end if;
  end if;

  return new;
end;
$$;

update public.users
set wilaya_id = 16
where wilaya_id is null and lower(btrim(city)) = 'algiers';

drop trigger if exists trg_sync_user_wilaya_id on public.users;
create trigger trg_sync_user_wilaya_id
  before insert or update of city on public.users
  for each row execute function public.sync_user_wilaya_id();

create or replace function public.protect_user_owned_update()
returns trigger
language plpgsql
set search_path = pg_catalog, public, extensions
as $$
begin
  if current_user in ('anon', 'authenticated')
    and (
      new.id is distinct from old.id
      or new.full_name is distinct from old.full_name
      or new.national_id is distinct from old.national_id
      or new.is_admin is distinct from old.is_admin
      or new.is_active is distinct from old.is_active
      or new.blood_type_verified is distinct from old.blood_type_verified
      or new.cooldown_until is distinct from old.cooldown_until
      or new.total_points is distinct from old.total_points
      or new.total_donations_count is distinct from old.total_donations_count
      or new.last_donation_date is distinct from old.last_donation_date
    )
  then
    raise exception using
      errcode = '42501',
      message = 'protected_profile_field';
  end if;

  return new;
end;
$$;

drop trigger if exists trg_protect_user_owned_update on public.users;
create trigger trg_protect_user_owned_update
  before update on public.users
  for each row execute function public.protect_user_owned_update();

create or replace function public.admin_correct_identity(
  p_user_id uuid,
  p_field_name text,
  p_new_value text,
  p_reason text
)
returns public.identity_corrections
language plpgsql
security definer
set search_path = pg_catalog, public, extensions
as $$
declare
  v_admin uuid := auth.uid();
  v_old_value text;
  v_correction public.identity_corrections;
begin
  if v_admin is null or not public.is_admin() then
    raise exception using errcode = 'P0001', message = 'admin_required';
  end if;

  if p_field_name not in ('full_name', 'national_id') then
    raise exception using errcode = '22023', message = 'unsupported_identity_field';
  end if;

  if nullif(btrim(p_new_value), '') is null then
    raise exception using errcode = '22023', message = 'new_value_required';
  end if;

  if nullif(btrim(p_reason), '') is null then
    raise exception using errcode = '22023', message = 'correction_reason_required';
  end if;

  select
    case
      when p_field_name = 'full_name' then full_name
      else national_id
    end
  into v_old_value
  from public.users
  where id = p_user_id and deleted_at is null
  for update;

  if not found then
    raise exception using errcode = 'P0001', message = 'user_not_found';
  end if;

  if p_field_name = 'full_name' then
    update public.users
    set full_name = btrim(p_new_value)
    where id = p_user_id;
  else
    update public.users
    set national_id = btrim(p_new_value)
    where id = p_user_id;
  end if;

  insert into public.identity_corrections (
    user_id,
    corrected_by,
    field_name,
    old_value,
    new_value,
    reason
  )
  values (
    p_user_id,
    v_admin,
    p_field_name,
    v_old_value,
    btrim(p_new_value),
    btrim(p_reason)
  )
  returning * into v_correction;

  return v_correction;
end;
$$;

create or replace view public.eligible_donors
with (security_invoker = true)
as
  select *
  from public.users
  where deleted_at is null
    and is_active
    and is_donor
    and is_available_for_donation
    and date_of_birth <= current_date - interval '18 years'
    and (cooldown_until is null or cooldown_until <= current_date);

create or replace view public.public_profiles
with (security_invoker = true)
as
  select
    id,
    username,
    full_name,
    avatar_url,
    blood_type,
    blood_type_verified,
    city,
    district,
    is_donor,
    is_recipient,
    total_points,
    total_donations_count,
    created_at,
    wilaya_id,
    active_mode
  from public.users
  where deleted_at is null;

drop policy if exists campaigns_select_active on public.campaigns;
drop policy if exists campaigns_insert_own on public.campaigns;
drop policy if exists campaigns_update_own on public.campaigns;
drop policy if exists campaigns_delete_admin on public.campaigns;

create policy campaigns_select_published
  on public.campaigns
  for select
  to authenticated
  using (
    deleted_at is null
    and published_at is not null
    and status in ('upcoming', 'active')
  );

create policy campaigns_admin_all
  on public.campaigns
  for all
  to authenticated
  using (public.is_admin())
  with check (public.is_admin());

drop policy if exists blood_requests_insert_own on public.blood_requests;
drop policy if exists blood_requests_update_own on public.blood_requests;
drop policy if exists appointments_insert_own on public.appointments;
drop policy if exists appointments_update_own on public.appointments;

create policy direct_invitations_select_involved
  on public.direct_invitations
  for select
  to authenticated
  using (
    donor_id = auth.uid()
    or public.is_admin()
    or exists (
      select 1
      from public.blood_requests r
      where r.id = direct_invitations.request_id
        and r.requested_by = auth.uid()
    )
  );

create policy donation_records_select_involved
  on public.donation_records
  for select
  to authenticated
  using (
    donor_id = auth.uid()
    or public.is_admin()
    or exists (
      select 1
      from public.blood_requests r
      where r.id = donation_records.request_id
        and r.requested_by = auth.uid()
    )
  );

create policy user_chronic_diseases_select_own
  on public.user_chronic_diseases
  for select
  to authenticated
  using (user_id = auth.uid() or public.is_admin());

create policy user_chronic_diseases_insert_own
  on public.user_chronic_diseases
  for insert
  to authenticated
  with check (user_id = auth.uid());

create policy user_chronic_diseases_delete_own
  on public.user_chronic_diseases
  for delete
  to authenticated
  using (user_id = auth.uid() or public.is_admin());

create policy identity_corrections_select_involved
  on public.identity_corrections
  for select
  to authenticated
  using (
    user_id = auth.uid()
    or corrected_by = auth.uid()
    or public.is_admin()
  );

create policy hospitals_admin_all
  on public.hospitals
  for all
  to authenticated
  using (public.is_admin())
  with check (public.is_admin());

create policy associations_admin_all
  on public.associations
  for all
  to authenticated
  using (public.is_admin())
  with check (public.is_admin());

create policy chronic_diseases_admin_all
  on public.chronic_diseases
  for all
  to authenticated
  using (public.is_admin())
  with check (public.is_admin());

revoke update on table public.users from authenticated;
grant update (
  username,
  phone,
  date_of_birth,
  gender,
  avatar_url,
  blood_type,
  city,
  district,
  location,
  fcm_token,
  weight,
  chronic_diseases,
  is_donor,
  is_recipient,
  active_mode,
  wilaya_id,
  is_available_for_donation
) on public.users to authenticated;

revoke insert, update, delete on table public.blood_requests
  from anon, authenticated;
revoke insert, update, delete on table public.appointments
  from anon, authenticated;
revoke insert, update, delete on table public.direct_invitations
  from anon, authenticated;
revoke all on table public.qr_tokens from anon, authenticated;
revoke insert, update, delete on table public.donation_records
  from anon, authenticated;
revoke insert, update, delete on table public.identity_corrections
  from anon, authenticated;
revoke insert, update, delete on table public.point_transactions
  from anon, authenticated;

grant select on table
  public.blood_requests,
  public.appointments,
  public.campaigns,
  public.direct_invitations,
  public.donation_records,
  public.identity_corrections,
  public.public_profiles,
  public.eligible_donors
to authenticated;

grant select, insert, delete on table public.user_chronic_diseases
  to authenticated;

grant insert, update, delete on table
  public.campaigns,
  public.hospitals,
  public.associations,
  public.chronic_diseases
to authenticated;

revoke update on table public.notifications from authenticated;
grant update (is_read) on public.notifications to authenticated;

revoke all on function public.admin_correct_identity(
  uuid,
  text,
  text,
  text
) from public;
grant execute on function public.admin_correct_identity(
  uuid,
  text,
  text,
  text
) to authenticated;

revoke all on function public.is_admin() from public;
grant execute on function public.is_admin() to authenticated;

revoke all on function public.protect_user_owned_update() from public;
revoke all on function public.sync_user_wilaya_id() from public;
revoke all on function public.set_updated_at() from public;
revoke all on function public.sync_total_points() from public;
revoke all on function public.on_appointment_completed() from public;
revoke all on function public.handle_new_user() from public;
