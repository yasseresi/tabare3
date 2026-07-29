-- ============================================================
-- تبرع (Tabara3) — Profile picture storage bucket + RLS
-- ============================================================

-- 1. Create the bucket if it does not exist.
insert into storage.buckets (id, name, public)
values ('profile_pic', 'profile_pic', true)
on conflict (id) do nothing;

-- 2. Enable RLS on storage.objects (idempotent if already enabled).
alter table storage.objects enable row level security;

-- 3. Policies (drop + recreate to keep migration idempotent).
-- Anyone can view avatars (public bucket behavior).
drop policy if exists profile_pic_select_public on storage.objects;
create policy profile_pic_select_public
  on storage.objects for select to authenticated, anon
  using (bucket_id = 'profile_pic');

-- Authenticated users can upload only into their own folder: <user_id>/...
drop policy if exists profile_pic_insert_own on storage.objects;
create policy profile_pic_insert_own
  on storage.objects for insert to authenticated
  with check (
    bucket_id = 'profile_pic'
    and (storage.foldername(name))[1] = auth.uid()::text
  );

-- Users can update/delete only their own avatar objects.
drop policy if exists profile_pic_update_own on storage.objects;
create policy profile_pic_update_own
  on storage.objects for update to authenticated
  using (
    bucket_id = 'profile_pic'
    and (storage.foldername(name))[1] = auth.uid()::text
  )
  with check (
    bucket_id = 'profile_pic'
    and (storage.foldername(name))[1] = auth.uid()::text
  );

drop policy if exists profile_pic_delete_own on storage.objects;
create policy profile_pic_delete_own
  on storage.objects for delete to authenticated
  using (
    bucket_id = 'profile_pic'
    and (storage.foldername(name))[1] = auth.uid()::text
  );
