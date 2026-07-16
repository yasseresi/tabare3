-- ============================================================
-- تبرع (Tabara3) — RLS Policies Migration
-- Every table has RLS enabled with explicit policies.
-- Uses security definer helper to avoid recursion.
-- ============================================================

-- ============================================================
-- HELPER: is_admin()
-- Runs as owner (security definer) to bypass RLS and avoid
-- infinite recursion when checking admin status from users table.
-- ============================================================
create or replace function public.is_admin()
returns boolean
language sql
stable
security definer
set search_path = public
as $$
  select coalesce(
    (select is_admin from public.users where id = auth.uid() and deleted_at is null),
    false
  );
$$;


-- ============================================================
-- USERS
-- SELECT: own row only (sensitive data). Use public_profiles view
--        for seeing other users' non-sensitive info.
-- INSERT: handled by auth trigger, not direct client insert.
-- UPDATE: own row only. Admin can update any.
-- ============================================================
alter table users enable row level security;

create policy users_select_own
  on users for select to authenticated
  using (id = auth.uid());

create policy users_update_own
  on users for update to authenticated
  using (id = auth.uid())
  with check (id = auth.uid());

create policy users_admin_all
  on users for all to authenticated
  using (public.is_admin())
  with check (public.is_admin());


-- ============================================================
-- BLOOD REQUESTS
-- SELECT: all authenticated see active requests (deleted_at null).
-- INSERT: user creates own (requested_by = auth.uid()).
-- UPDATE: owner or admin. DELETE: soft-delete via update.
-- ============================================================
alter table blood_requests enable row level security;

create policy blood_requests_select_active
  on blood_requests for select to authenticated
  using (deleted_at is null);

create policy blood_requests_insert_own
  on blood_requests for insert to authenticated
  with check (requested_by = auth.uid());

create policy blood_requests_update_own
  on blood_requests for update to authenticated
  using (requested_by = auth.uid() or public.is_admin())
  with check (requested_by = auth.uid() or public.is_admin());

create policy blood_requests_delete_admin
  on blood_requests for delete to authenticated
  using (public.is_admin());


-- ============================================================
-- CAMPAIGNS
-- SELECT: all authenticated see active campaigns.
-- INSERT: any authenticated user (created_by = auth.uid()).
-- UPDATE: creator or admin. DELETE: admin only.
-- ============================================================
alter table campaigns enable row level security;

create policy campaigns_select_active
  on campaigns for select to authenticated
  using (deleted_at is null);

create policy campaigns_insert_own
  on campaigns for insert to authenticated
  with check (created_by = auth.uid());

create policy campaigns_update_own
  on campaigns for update to authenticated
  using (created_by = auth.uid() or public.is_admin())
  with check (created_by = auth.uid() or public.is_admin());

create policy campaigns_delete_admin
  on campaigns for delete to authenticated
  using (public.is_admin());


-- ============================================================
-- APPOINTMENTS
-- SELECT: donor sees own; request creator sees appointments
--        for their request; campaign creator sees appointments
--        for their campaign; admin sees all.
-- INSERT: donor creates own.
-- UPDATE: donor or admin. DELETE: admin only.
-- ============================================================
alter table appointments enable row level security;

create policy appointments_select_involved
  on appointments for select to authenticated
  using (
    donor_id = auth.uid()
    or public.is_admin()
    or exists (
      select 1 from blood_requests br
      where br.id = appointments.blood_request_id
        and br.requested_by = auth.uid()
    )
    or exists (
      select 1 from campaigns c
      where c.id = appointments.campaign_id
        and c.created_by = auth.uid()
    )
  );

create policy appointments_insert_own
  on appointments for insert to authenticated
  with check (donor_id = auth.uid());

create policy appointments_update_own
  on appointments for update to authenticated
  using (donor_id = auth.uid() or public.is_admin())
  with check (donor_id = auth.uid() or public.is_admin());

create policy appointments_delete_admin
  on appointments for delete to authenticated
  using (public.is_admin());


-- ============================================================
-- POINT TRANSACTIONS
-- SELECT: donor sees own. Admin sees all.
-- INSERT: service_role or admin (system/edge function writes).
-- UPDATE/DELETE: admin only (corrections). Normally immutable.
-- ============================================================
alter table point_transactions enable row level security;

create policy point_transactions_select_own
  on point_transactions for select to authenticated
  using (donor_id = auth.uid() or public.is_admin());

create policy point_transactions_insert_admin
  on point_transactions for insert to authenticated
  with check (public.is_admin());

create policy point_transactions_update_admin
  on point_transactions for update to authenticated
  using (public.is_admin())
  with check (public.is_admin());

create policy point_transactions_delete_admin
  on point_transactions for delete to authenticated
  using (public.is_admin());


-- ============================================================
-- LEVELS
-- SELECT: all authenticated. Write: admin only.
-- ============================================================
alter table levels enable row level security;

create policy levels_select_all
  on levels for select to authenticated
  using (true);

create policy levels_write_admin
  on levels for all to authenticated
  using (public.is_admin())
  with check (public.is_admin());


-- ============================================================
-- BADGES
-- SELECT: all authenticated. Write: admin only.
-- ============================================================
alter table badges enable row level security;

create policy badges_select_all
  on badges for select to authenticated
  using (true);

create policy badges_write_admin
  on badges for all to authenticated
  using (public.is_admin())
  with check (public.is_admin());


-- ============================================================
-- USER BADGES
-- SELECT: user sees own. Admin sees all.
-- INSERT: admin/system only. DELETE: admin only.
-- ============================================================
alter table user_badges enable row level security;

create policy user_badges_select_own
  on user_badges for select to authenticated
  using (user_id = auth.uid() or public.is_admin());

create policy user_badges_insert_admin
  on user_badges for insert to authenticated
  with check (public.is_admin());

create policy user_badges_delete_admin
  on user_badges for delete to authenticated
  using (public.is_admin());


-- ============================================================
-- NOTIFICATIONS
-- SELECT: user sees own. UPDATE: user marks own as read.
-- INSERT: admin/system only. DELETE: admin only.
-- ============================================================
alter table notifications enable row level security;

create policy notifications_select_own
  on notifications for select to authenticated
  using (user_id = auth.uid());

create policy notifications_update_own
  on notifications for update to authenticated
  using (user_id = auth.uid())
  with check (user_id = auth.uid());

create policy notifications_insert_admin
  on notifications for insert to authenticated
  with check (public.is_admin());

create policy notifications_delete_admin
  on notifications for delete to authenticated
  using (public.is_admin());


-- ============================================================
-- REFERRALS
-- SELECT: referrer or referred sees own. Admin sees all.
-- INSERT: any authenticated user (as referrer).
-- UPDATE/DELETE: admin only.
-- ============================================================
alter table referrals enable row level security;

create policy referrals_select_involved
  on referrals for select to authenticated
  using (
    referrer_id = auth.uid()
    or referred_id = auth.uid()
    or public.is_admin()
  );

create policy referrals_insert_own
  on referrals for insert to authenticated
  with check (referrer_id = auth.uid());

create policy referrals_update_admin
  on referrals for update to authenticated
  using (public.is_admin())
  with check (public.is_admin());

create policy referrals_delete_admin
  on referrals for delete to authenticated
  using (public.is_admin());


-- ============================================================
-- BLOOD TYPE COMPATIBILITY
-- SELECT: all authenticated. Write: admin only.
-- ============================================================
alter table blood_type_compatibility enable row level security;

create policy btc_select_all
  on blood_type_compatibility for select to authenticated
  using (true);

create policy btc_write_admin
  on blood_type_compatibility for all to authenticated
  using (public.is_admin())
  with check (public.is_admin());
