begin;

create extension if not exists pgtap with schema extensions;

select plan(26);

select ok(
  has_table_privilege('authenticated', 'public.users', 'SELECT'),
  'authenticated users may read their own profile through RLS'
);

select ok(
  not has_table_privilege('authenticated', 'public.users', 'UPDATE'),
  'authenticated users do not have blanket profile update access'
);
select ok(
  has_column_privilege('authenticated', 'public.users', 'phone', 'UPDATE'),
  'users may update their phone through the own-row policy'
);
select ok(
  has_column_privilege(
    'authenticated',
    'public.users',
    'is_available_for_donation',
    'UPDATE'
  ),
  'users may control manual donation availability'
);
select ok(
  not has_column_privilege(
    'authenticated',
    'public.users',
    'full_name',
    'UPDATE'
  ),
  'full name is not directly editable'
);
select ok(
  not has_column_privilege(
    'authenticated',
    'public.users',
    'national_id',
    'UPDATE'
  ),
  'national ID is not directly editable'
);
select ok(
  not has_column_privilege('authenticated', 'public.users', 'is_admin', 'UPDATE'),
  'admin role is system owned'
);
select ok(
  not has_column_privilege(
    'authenticated',
    'public.users',
    'cooldown_until',
    'UPDATE'
  ),
  'cooldown is system owned'
);
select ok(
  not has_column_privilege(
    'authenticated',
    'public.users',
    'total_points',
    'UPDATE'
  ),
  'points are system owned'
);
select ok(
  not has_table_privilege(
    'authenticated',
    'public.blood_requests',
    'INSERT'
  ),
  'requests cannot bypass creation RPC validation'
);
select ok(
  not has_table_privilege(
    'authenticated',
    'public.blood_requests',
    'UPDATE'
  ),
  'requests cannot bypass update RPC validation'
);
select ok(
  not has_table_privilege(
    'authenticated',
    'public.appointments',
    'INSERT'
  ),
  'appointments cannot bypass acceptance RPC validation'
);
select ok(
  not has_table_privilege(
    'authenticated',
    'public.appointments',
    'UPDATE'
  ),
  'donors cannot self-complete appointments'
);
select ok(
  not exists (
    select 1
    from pg_policies
    where schemaname = 'public'
      and tablename = 'campaigns'
      and policyname in ('campaigns_insert_own', 'campaigns_update_own')
  ),
  'campaign creator policies cannot bypass admin governance'
);
select ok(
  exists (
    select 1
    from pg_policies
    where schemaname = 'public'
      and tablename = 'campaigns'
      and policyname = 'campaigns_admin_all'
  ),
  'campaign writes require the admin RLS policy'
);
select ok(
  not has_table_privilege(
    'authenticated',
    'public.direct_invitations',
    'INSERT'
  ),
  'invitations cannot bypass the urgent-only RPC'
);
select ok(
  not has_table_privilege('authenticated', 'public.qr_tokens', 'SELECT'),
  'stored QR hashes are never exposed through the Data API'
);
select ok(
  not has_table_privilege(
    'authenticated',
    'public.donation_records',
    'INSERT'
  ),
  'donation records are written only by verified redemption'
);
select ok(
  has_column_privilege(
    'authenticated',
    'public.notifications',
    'is_read',
    'UPDATE'
  ),
  'users can mark their notifications read'
);
select ok(
  not has_column_privilege(
    'authenticated',
    'public.notifications',
    'title',
    'UPDATE'
  ),
  'users cannot rewrite notification content'
);
select results_eq(
  $$
    select 'security_invoker=true' = any(coalesce(reloptions, array[]::text[]))
    from pg_class c
    join pg_namespace n on n.oid = c.relnamespace
    where n.nspname = 'public' and c.relname = 'eligible_donors'
  $$,
  array[true],
  'eligible donor view obeys caller RLS'
);
select results_eq(
  $$
    select 'security_invoker=true' = any(coalesce(reloptions, array[]::text[]))
    from pg_class c
    join pg_namespace n on n.oid = c.relnamespace
    where n.nspname = 'public' and c.relname = 'public_profiles'
  $$,
  array[true],
  'public profile view obeys caller RLS'
);
select results_eq(
  $$
    select count(*)::bigint
    from pg_policies
    where schemaname = 'public'
      and tablename = 'campaigns'
      and policyname = 'campaigns_select_published'
  $$,
  array[1::bigint],
  'only the published campaign read policy is installed'
);
select has_function(
  'public',
  'admin_correct_identity',
  array['uuid', 'text', 'text', 'text'],
  'identity corrections use an audited admin RPC'
);
select results_eq(
  $$
    select count(*)::bigint
    from pg_proc p
    join pg_namespace n on n.oid = p.pronamespace
    where n.nspname = 'public'
      and p.proname in (
        'is_admin',
        'set_updated_at',
        'sync_total_points',
        'on_appointment_completed',
        'handle_new_user',
        'admin_correct_identity'
      )
      and p.proconfig @> array['search_path=pg_catalog, public, extensions']
  $$,
  array[6::bigint],
  'legacy and admin functions pin a safe search path'
);

select results_eq(
  $$
    select count(*)::bigint
    from pg_proc p
    join pg_namespace n on n.oid = p.pronamespace
    where n.nspname = 'public'
      and p.proname in (
        'accept_blood_request',
        'admin_correct_identity',
        'cancel_appointment',
        'cancel_blood_request',
        'compatible_donors_for_request',
        'create_blood_request',
        'handle_new_user',
        'is_admin',
        'issue_campaign_qr',
        'issue_request_qr',
        'redeem_campaign_qr',
        'redeem_request_qr',
        'respond_direct_invitation',
        'send_direct_invitation',
        'update_blood_request'
      )
      and has_function_privilege('anon', p.oid, 'EXECUTE')
  $$,
  array[0::bigint],
  'anonymous clients cannot execute app security-definer functions'
);

select * from finish();
rollback;
