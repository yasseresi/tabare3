-- ============================================================
-- تبرع (Tabara3) — Grant authenticated UPDATE on users.is_active
-- ============================================================
-- 20260730104443_harden_rls_and_admin_boundaries revoked table-wide
-- UPDATE on public.users and re-granted a column allow-list, but the
-- account-status toggle column `is_active` (added in 00004) was omitted.
-- The profile update payload always includes is_active, so every save
-- hit "permission denied for column is_active". Add the missing grant.
grant update (is_active) on public.users to authenticated;
