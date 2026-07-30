create or replace function public.request_donors_for_recipient(
  p_request_id uuid
)
returns table (
  donor_id uuid,
  full_name text,
  blood_type public.blood_type_enum,
  appointment_id uuid,
  status public.appointment_status_enum,
  scheduled_at timestamptz,
  completed_at timestamptz
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
    u.id,
    u.full_name,
    u.blood_type,
    a.id,
    a.status,
    a.scheduled_at,
    a.completed_at
  from public.appointments a
  join public.users u on u.id = a.donor_id
  where a.blood_request_id = p_request_id
    and a.deleted_at is null
    and a.status in ('pending', 'confirmed', 'completed')
  order by a.created_at;
end;
$$;

revoke all on function public.request_donors_for_recipient(uuid) from public;
revoke all on function public.request_donors_for_recipient(uuid) from anon;
grant execute on function public.request_donors_for_recipient(uuid)
  to authenticated;
