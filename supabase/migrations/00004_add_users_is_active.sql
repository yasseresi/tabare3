-- ============================================================
-- تبرع (Tabara3) — Add account-status column to users
-- ============================================================

alter table public.users
  add column if not exists is_active boolean not null default true;

comment on column public.users.is_active is 'Account availability toggle (true = active/visible, false = unavailable) controlled from profile.';
