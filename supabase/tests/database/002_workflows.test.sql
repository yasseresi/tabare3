begin;

create extension if not exists pgtap with schema extensions;

select plan(28);

select has_column(
  'public',
  'users',
  'is_available_for_donation',
  'donation availability is independent from account state and active mode'
);

select has_column(
  'public',
  'blood_requests',
  'beneficiary_type',
  'requests identify whether they are for the requester or another patient'
);
select has_table(
  'public',
  'request_patients',
  'private patient snapshots are separated from the public request feed'
);

select has_function(
  'public',
  'create_blood_request',
  array[
    'uuid',
    'beneficiary_type_enum',
    'text',
    'text',
    'blood_type_enum',
    'numeric',
    'text',
    'text',
    'date',
    'blood_type_enum',
    'request_urgency_enum',
    'integer',
    'timestamp with time zone',
    'text'
  ],
  'recipient request creation is an RPC'
);
select has_function(
  'public',
  'update_blood_request',
  array[
    'uuid',
    'uuid',
    'blood_type_enum',
    'request_urgency_enum',
    'integer',
    'timestamp with time zone',
    'text'
  ],
  'recipient request updates are an RPC'
);
select has_function(
  'public',
  'cancel_blood_request',
  array['uuid', 'text'],
  'request cancellation is an RPC'
);
select has_function(
  'public',
  'accept_blood_request',
  array['uuid', 'timestamp with time zone'],
  'request acceptance is an RPC'
);
select has_function(
  'public',
  'cancel_appointment',
  array['uuid', 'text'],
  'appointment cancellation is an RPC'
);
select has_function(
  'public',
  'send_direct_invitation',
  array['uuid', 'uuid'],
  'urgent invitations are sent through an RPC'
);
select has_function(
  'public',
  'respond_direct_invitation',
  array['uuid', 'boolean', 'timestamp with time zone'],
  'invitation responses are atomic'
);
select has_function(
  'public',
  'issue_request_qr',
  array['uuid'],
  'request QR issuance is server controlled'
);
select has_function(
  'public',
  'redeem_request_qr',
  array['text'],
  'request QR redemption is server controlled'
);
select has_function(
  'public',
  'issue_campaign_qr',
  array['uuid'],
  'campaign QR issuance is server controlled'
);
select has_function(
  'public',
  'redeem_campaign_qr',
  array['text'],
  'campaign QR redemption is server controlled'
);
select has_function(
  'public',
  'compatible_donors_for_request',
  array['uuid'],
  'compatibility matching remains database managed'
);
select has_function(
  'public',
  'request_donors_for_recipient',
  array['uuid'],
  'recipient request donor history is exposed through a privacy-limited RPC'
);
select has_function(
  'public',
  'request_invitations_for_recipient',
  array['uuid'],
  'recipient invitation statuses are exposed through a privacy-limited RPC'
);
select has_function(
  'public',
  'compatible_requests_for_donor',
  array[]::text[],
  'donor compatibility and eligibility are database managed'
);

select results_eq(
  $$
    select count(*)::bigint
    from pg_proc p
    join pg_namespace n on n.oid = p.pronamespace
    where n.nspname = 'public'
      and p.proname in (
        'create_blood_request',
        'update_blood_request',
        'cancel_blood_request',
        'accept_blood_request',
        'cancel_appointment',
        'send_direct_invitation',
        'respond_direct_invitation',
        'issue_request_qr',
        'redeem_request_qr',
        'issue_campaign_qr',
        'redeem_campaign_qr',
        'compatible_donors_for_request',
        'request_donors_for_recipient',
        'request_invitations_for_recipient',
        'compatible_requests_for_donor'
      )
      and p.prosecdef
  $$,
  array[15::bigint],
  'all workflow RPCs enforce authorization inside security-definer functions'
);

select results_eq(
  $$
    select count(*)::bigint
    from pg_proc p
    join pg_namespace n on n.oid = p.pronamespace
    where n.nspname = 'public'
      and p.proname in (
        'create_blood_request',
        'update_blood_request',
        'cancel_blood_request',
        'accept_blood_request',
        'cancel_appointment',
        'send_direct_invitation',
        'respond_direct_invitation',
        'issue_request_qr',
        'redeem_request_qr',
        'issue_campaign_qr',
        'redeem_campaign_qr',
        'compatible_donors_for_request'
      )
      and p.proconfig @> array['search_path=pg_catalog, public, extensions']
  $$,
  array[12::bigint],
  'workflow RPCs pin a safe search path'
);

select has_index(
  'public',
  'blood_requests',
  'uq_blood_requests_one_active_per_recipient',
  'one active request is enforced'
);
select has_index(
  'public',
  'appointments',
  'uq_appointments_one_pending_per_donor',
  'one pending appointment is enforced'
);
select has_index(
  'public',
  'direct_invitations',
  'uq_direct_invitations_pending',
  'duplicate pending invitations are prevented'
);
select has_index(
  'public',
  'donation_records',
  'uq_donation_records_campaign_donor',
  'campaign QR redemption is one donation per donor'
);
select has_index(
  'public',
  'donation_records',
  'uq_donation_records_appointment',
  'request QR replay cannot duplicate a donation record'
);

-- Editing an open request must notify the donors who already accepted it, so a
-- recipient who changes the hospital/time/urgency does not leave applicants
-- acting on stale details. The RPC therefore emits a `request_update`
-- notification to every active appointment on the request.
select ok(
  pg_get_functiondef(
    (
      select p.oid
      from pg_proc p
      join pg_namespace n on n.oid = p.pronamespace
      where n.nspname = 'public' and p.proname = 'update_blood_request'
    )
  ) like '%request_update%',
  'editing an open request notifies its accepted donors'
);

-- Cancelling a request voids the donors' appointments; those donors must be
-- told so they do not travel to a cancelled donation. The RPC therefore writes
-- a notification for every appointment it cancels.
select ok(
  pg_get_functiondef(
    (
      select p.oid
      from pg_proc p
      join pg_namespace n on n.oid = p.pronamespace
      where n.nspname = 'public' and p.proname = 'cancel_blood_request'
    )
  ) like '%insert into public.notifications%',
  'cancelling a request notifies the donors whose appointments are voided'
);

-- When a donor backs out of an appointment, the recipient must be told so they
-- can chase another donor. cancel_appointment therefore notifies the request
-- owner.
select ok(
  pg_get_functiondef(
    (
      select p.oid
      from pg_proc p
      join pg_namespace n on n.oid = p.pronamespace
      where n.nspname = 'public' and p.proname = 'cancel_appointment'
    )
  ) like '%insert into public.notifications%',
  'a donor cancelling their appointment notifies the request owner'
);

select * from finish();
rollback;
