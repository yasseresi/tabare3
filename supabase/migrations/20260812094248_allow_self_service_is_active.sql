-- ============================================================
-- تبرع (Tabara3) — Allow self-service account availability
-- ============================================================
--
-- `users.is_active` is a user-facing availability toggle ("Active /
-- Unavailable") on the profile screen, letting a donor/recipient pause their
-- own visibility. It was mistakenly grouped with identity/integrity fields in
-- protect_user_owned_update(), so every toggle raised 'protected_profile_field'
-- (42501) and the setting could never be saved.
--
-- Drop `is_active` from the protected set. The remaining fields (identity,
-- admin, verification, points, cooldown, donation history) stay owner-locked.
-- CREATE OR REPLACE keeps the existing trigger binding and grants intact.

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

-- Preserve the hardening posture (function is invoked by the trigger, not
-- called directly by clients).
revoke all on function public.protect_user_owned_update() from public;
