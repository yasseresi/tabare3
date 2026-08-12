-- Let the sign-up form tell a user their username is taken before it submits.
--
-- Usernames are mapped onto a fake email domain and handed to GoTrue, so a
-- collision only surfaced as a raw "user already registered" after the whole
-- three-step form had been filled in. `public.users` is closed to anon by RLS,
-- so the pre-flight check goes through this `security definer` function: it
-- answers with a bare boolean and discloses nothing else about the account.
--
-- The answer is advisory — it can go stale between the check and the sign-up —
-- so the unique constraint on public.users.username stays the authority.

create or replace function public.is_username_available(p_username text)
returns boolean
language sql
stable
security definer
-- Empty search_path: every function and table below is schema-qualified, so
-- nothing resolves through a path the caller controls. (pg_catalog is always
-- searched implicitly, which is what keeps the built-in operators working.)
set search_path = ''
as $$
  select coalesce(pg_catalog.btrim(p_username), '') <> ''
     and not exists (
       select 1
       from public.users u
       where pg_catalog.lower(u.username)
           = pg_catalog.lower(pg_catalog.btrim(p_username))
     );
$$;

comment on function public.is_username_available(text) is
  'Advisory pre-flight check for the sign-up form: false when the username is blank or already claimed. The unique constraint on public.users.username remains the authority.';

-- Sign-up happens before a session exists, so anon needs this one. It is the
-- deliberate exception to 20260730105254_revoke_anonymous_rpc_access.sql: the
-- boolean says nothing an attacker could not learn by attempting the sign-up.
grant execute on function public.is_username_available(text)
  to anon, authenticated;
