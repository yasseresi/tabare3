-- Enable Supabase Realtime for public.notifications so clients receive
-- inserts/updates live (unread badge + notification centre without a manual
-- refresh). RLS still scopes every streamed row to user_id = auth.uid().
--
-- replica identity full ships the full old row on UPDATE/DELETE, which the
-- realtime server needs to re-evaluate the row-level filter (e.g. is_read
-- flipping to true must re-emit so the client's unread count drops live).

do $$
begin
  if exists (
    select 1
    from pg_catalog.pg_publication
    where pubname = 'supabase_realtime'
  ) and not exists (
    select 1
    from pg_catalog.pg_publication_tables
    where pubname = 'supabase_realtime'
      and schemaname = 'public'
      and tablename = 'notifications'
  ) then
    execute 'alter publication supabase_realtime add table public.notifications';
  end if;
end
$$;

alter table public.notifications replica identity full;
