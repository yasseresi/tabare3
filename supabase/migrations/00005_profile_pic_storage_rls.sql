-- ============================================================
-- تبرع (Tabara3) — Profile picture storage bucket + RLS
-- ============================================================

-- 1. Create the bucket if it does not exist.
insert into storage.buckets (id, name, public)
values ('profile_pic', 'profile_pic', true)
on conflict (id) do nothing;

-- 2. Enable RLS on storage.objects only if it is not already enabled.
-- This avoids the "must be owner of table objects" error when the migration
-- is executed by a non-owner role (e.g. some MCP/CLI contexts). The actual
-- policy drop/create statements still require ownership, so this migration
-- should be applied via the Supabase Dashboard SQL Editor or a role that owns
-- storage.objects.
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1
    FROM pg_class c
    JOIN pg_namespace n ON n.oid = c.relnamespace
    WHERE c.relname = 'objects'
      AND n.nspname = 'storage'
      AND c.relrowsecurity
  ) THEN
    EXECUTE 'ALTER TABLE storage.objects ENABLE ROW LEVEL SECURITY';
  END IF;
END $$;

  -- 3. Policies (drop + recreate to keep migration idempotent).
  -- Users can only list their own avatar objects (no broad public listing).
  drop policy if exists profile_pic_select_public on storage.objects;
  create policy profile_pic_select_own
    on storage.objects for select to authenticated
    using (
      bucket_id = 'profile_pic'
      and (storage.foldername(name))[1] = auth.uid()::text
    );

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
