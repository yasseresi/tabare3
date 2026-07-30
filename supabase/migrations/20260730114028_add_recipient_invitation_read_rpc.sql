create or replace function public.request_invitations_for_recipient(
  p_request_id uuid
)
returns table (
  invitation_id uuid,
  donor_id uuid,
  full_name text,
  blood_type public.blood_type_enum,
  status public.invitation_status_enum,
  appointment_id uuid,
  expires_at timestamptz,
  responded_at timestamptz,
  created_at timestamptz
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
    from public.blood_requests r
    where r.id = p_request_id
      and (r.requested_by = v_caller or public.is_admin())
      and r.deleted_at is null
  ) then
    raise exception using errcode = 'P0001', message = 'request_not_accessible';
  end if;

  return query
  select
    i.id,
    u.id,
    u.full_name,
    u.blood_type,
    case
      when i.status = 'sent' and i.expires_at <= now()
        then 'expired'::public.invitation_status_enum
      else i.status
    end,
    i.appointment_id,
    i.expires_at,
    i.responded_at,
    i.created_at
  from public.direct_invitations i
  join public.users u on u.id = i.donor_id
  where i.request_id = p_request_id
  order by i.created_at desc;
end;
$$;

revoke all on function public.request_invitations_for_recipient(uuid)
  from public;
revoke all on function public.request_invitations_for_recipient(uuid)
  from anon;
grant execute on function public.request_invitations_for_recipient(uuid)
  to authenticated;
