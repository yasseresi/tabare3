-- Unified QR redeem dispatcher.
--
-- The donor scan-first flow captures a token without knowing whether it belongs
-- to a blood request or a campaign. This function looks up the token kind by its
-- hash and delegates to the existing hardened redeem functions, so the client
-- needs neither a kind picker nor a second round-trip.
--
-- Security: SECURITY DEFINER with a pinned search_path (extension/builtin funcs
-- are schema-qualified). All real validation (single-use, expiry, appointment,
-- eligibility, points, cooldown, notifications) stays inside the delegated
-- functions; this wrapper only resolves the kind. Granted to authenticated only.

create or replace function public.redeem_qr(
  p_token text
)
returns public.donation_records
language plpgsql
security definer
set search_path = pg_catalog, public, extensions
as $$
declare
  v_kind public.qr_token_kind_enum;
begin
  if auth.uid() is null then
    raise exception using errcode = 'P0001', message = 'unauthenticated';
  end if;

  select q.kind
  into v_kind
  from public.qr_tokens q
  where q.token_hash = encode(extensions.digest(p_token, 'sha256'), 'hex')
  limit 1;

  if v_kind is null then
    raise exception using errcode = 'P0001', message = 'qr_invalid';
  end if;

  if v_kind = 'request' then
    return public.redeem_request_qr(p_token);
  else
    return public.redeem_campaign_qr(p_token);
  end if;
end;
$$;

revoke all on function public.redeem_qr(text) from public;
-- Supabase default privileges auto-grant execute on new public functions to
-- anon; strip it so only authenticated callers reach the (auth-gated) function.
revoke execute on function public.redeem_qr(text) from anon;
grant execute on function public.redeem_qr(text) to authenticated;
