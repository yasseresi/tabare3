create or replace function public.issue_request_qr(
  p_request_id uuid
)
returns table (token text, expires_at timestamptz)
language plpgsql
security definer
set search_path = pg_catalog, public, extensions
as $$
declare
  v_caller uuid := auth.uid();
  v_token text;
  v_expires_at timestamptz;
begin
  if v_caller is null then
    raise exception using errcode = 'P0001', message = 'unauthenticated';
  end if;

  select least(
    now() + interval '15 minutes',
    coalesce(r.needed_by, 'infinity'::timestamptz),
    coalesce(r.expires_at, 'infinity'::timestamptz)
  )
  into v_expires_at
  from public.blood_requests r
  where r.id = p_request_id
    and r.requested_by = v_caller
    and r.status = 'open'
    and r.deleted_at is null
  for update;

  if not found or v_expires_at <= now() then
    raise exception using errcode = 'P0001', message = 'request_not_qr_eligible';
  end if;

  delete from public.qr_tokens q
  where q.request_id = p_request_id
    and q.consumed_at is null
    and q.expires_at > now();

  v_token := encode(extensions.gen_random_bytes(32), 'hex');

  insert into public.qr_tokens (
    kind,
    token_hash,
    request_id,
    issued_by,
    expires_at
  )
  values (
    'request',
    encode(extensions.digest(v_token, 'sha256'), 'hex'),
    p_request_id,
    v_caller,
    v_expires_at
  );

  return query select v_token, v_expires_at;
end;
$$;

create or replace function public.issue_campaign_qr(
  p_campaign_id uuid
)
returns table (token text, expires_at timestamptz)
language plpgsql
security definer
set search_path = pg_catalog, public, extensions
as $$
declare
  v_caller uuid := auth.uid();
  v_token text;
  v_expires_at timestamptz;
begin
  if v_caller is null or not public.is_admin() then
    raise exception using errcode = 'P0001', message = 'admin_required';
  end if;

  select c.ends_at
  into v_expires_at
  from public.campaigns c
  where c.id = p_campaign_id
    and c.published_at is not null
    and c.status in ('upcoming', 'active')
    and c.deleted_at is null
    and c.ends_at > now()
  for update;

  if not found then
    raise exception using errcode = 'P0001', message = 'campaign_not_qr_eligible';
  end if;

  delete from public.qr_tokens q
  where q.campaign_id = p_campaign_id and q.expires_at > now();

  v_token := encode(extensions.gen_random_bytes(32), 'hex');

  insert into public.qr_tokens (
    kind,
    token_hash,
    campaign_id,
    issued_by,
    expires_at
  )
  values (
    'campaign',
    encode(extensions.digest(v_token, 'sha256'), 'hex'),
    p_campaign_id,
    v_caller,
    v_expires_at
  );

  return query select v_token, v_expires_at;
end;
$$;
