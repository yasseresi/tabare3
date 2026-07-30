begin;

create extension if not exists pgtap with schema extensions;

select plan(34);

select has_table('public', 'wilayas', 'wilayas reference table exists');
select has_table('public', 'hospitals', 'hospitals reference table exists');
select has_table('public', 'associations', 'associations reference table exists');
select has_table(
  'public',
  'chronic_diseases',
  'chronic diseases reference table exists'
);
select has_table(
  'public',
  'user_chronic_diseases',
  'private user chronic diseases relation exists'
);
select has_table(
  'public',
  'direct_invitations',
  'urgent direct invitations table exists'
);
select has_table('public', 'qr_tokens', 'one-time QR token table exists');
select has_table(
  'public',
  'donation_records',
  'verified donation record table exists'
);
select has_table(
  'public',
  'identity_corrections',
  'admin identity correction audit table exists'
);
select has_table(
  'public',
  'blood_type_compatibility',
  'database-managed blood compatibility table exists'
);

select has_column(
  'public',
  'users',
  'active_mode',
  'users expose a canonical active mode'
);
select has_column(
  'public',
  'users',
  'wilaya_id',
  'users reference a governed wilaya'
);
select has_column(
  'public',
  'users',
  'cooldown_until',
  'users persist donation cooldown'
);
select has_column(
  'public',
  'blood_requests',
  'hospital_id',
  'requests reference a governed hospital'
);
select has_column(
  'public',
  'blood_requests',
  'wilaya_id',
  'requests denormalize wilaya for matching'
);
select has_column(
  'public',
  'blood_requests',
  'needed_by',
  'requests persist the optional needed-by deadline'
);
select has_column(
  'public',
  'direct_invitations',
  'expires_at',
  'direct invitations have an expiry'
);
select has_column(
  'public',
  'direct_invitations',
  'status',
  'direct invitations have a lifecycle status'
);
select has_column(
  'public',
  'qr_tokens',
  'token_hash',
  'QR tokens persist only a token hash'
);
select has_column(
  'public',
  'qr_tokens',
  'consumed_at',
  'QR tokens record one-time consumption'
);

select has_type(
  'public',
  'user_mode_enum',
  'donor and recipient modes use a database enum'
);
select has_type(
  'public',
  'invitation_status_enum',
  'invitation lifecycle uses a database enum'
);
select enum_has_labels(
  'public',
  'request_urgency_enum',
  array['semi_urgent', 'urgent', 'normal'],
  'requests use the three agreed priority levels'
);

select fk_ok(
  'public',
  'users',
  'id',
  'auth',
  'users',
  'id',
  'public profiles retain Supabase Auth UUID identities'
);
select fk_ok(
  'public',
  'blood_requests',
  'requested_by',
  'public',
  'users',
  'id',
  'requests reference UUID-backed public profiles'
);

select results_eq(
  'select count(*) from public.wilayas',
  array[69::bigint],
  'all 69 Algerian wilayas are seeded'
);
select results_eq(
  'select count(*) from public.blood_type_compatibility',
  array[27::bigint],
  'the complete ABO/Rh red-cell compatibility mapping is seeded'
);

select has_index(
  'public',
  'blood_requests',
  'uq_blood_requests_one_active_per_recipient',
  'a recipient can have only one active request'
);
select has_index(
  'public',
  'appointments',
  'uq_appointments_one_pending_per_donor',
  'a donor can have only one pending appointment'
);
select has_index(
  'public',
  'qr_tokens',
  'uq_qr_tokens_token_hash',
  'QR token hashes are unique'
);

select results_eq(
  $$
    select policyname
    from pg_policies
    where schemaname = 'public'
      and tablename = 'wilayas'
      and policyname = 'wilayas_select_authenticated'
  $$,
  array['wilayas_select_authenticated'::name],
  'authenticated users can read wilayas through RLS'
);
select results_eq(
  $$
    select policyname
    from pg_policies
    where schemaname = 'public'
      and tablename = 'hospitals'
      and policyname = 'hospitals_select_active_authenticated'
  $$,
  array['hospitals_select_active_authenticated'::name],
  'authenticated users can read active hospitals through RLS'
);
select results_eq(
  $$
    select policyname
    from pg_policies
    where schemaname = 'public'
      and tablename = 'associations'
      and policyname = 'associations_select_active_authenticated'
  $$,
  array['associations_select_active_authenticated'::name],
  'authenticated users can read active associations through RLS'
);
select results_eq(
  $$
    select policyname
    from pg_policies
    where schemaname = 'public'
      and tablename = 'chronic_diseases'
      and policyname = 'chronic_diseases_select_active_authenticated'
  $$,
  array['chronic_diseases_select_active_authenticated'::name],
  'authenticated users can read active chronic diseases through RLS'
);

select * from finish();
rollback;
