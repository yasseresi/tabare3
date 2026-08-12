-- Behavioural end-to-end proof that the notification flow fires on both sides.
--
-- Unlike 002 (which asserts on function source), this test seeds a recipient, a
-- donor, two open requests and their accepted appointments, then actually calls
-- the workflow RPCs as each party and asserts the resulting notification rows.
-- auth.uid() is driven through request.jwt.claims, exactly as PostgREST does.

begin;

create extension if not exists pgtap with schema extensions;

select plan(4);

-- Fixtures -------------------------------------------------------------------
-- public.users rows are created by the on-signup trigger from auth metadata,
-- so seed auth.users with the required metadata keys and let it populate them.
insert into auth.users (id, raw_user_meta_data)
values
  (
    '11111111-0000-4000-8000-000000000001',
    jsonb_build_object(
      'username', 'flow_recipient', 'full_name', 'Flow Recipient',
      'date_of_birth', '1990-01-01', 'gender', 'male',
      'phone', '0555000001', 'blood_type', 'O+', 'city', 'Alger'
    )
  ),
  (
    '22222222-0000-4000-8000-000000000002',
    jsonb_build_object(
      'username', 'flow_donor', 'full_name', 'Flow Donor',
      'date_of_birth', '1990-01-01', 'gender', 'male',
      'phone', '0555000002', 'blood_type', 'O+', 'city', 'Alger'
    )
  ),
  -- A second recipient: a recipient may hold only one open request, so
  -- request B (the cancel case) belongs to a different owner than request A.
  (
    '33333333-0000-4000-8000-000000000003',
    jsonb_build_object(
      'username', 'flow_recipient_b', 'full_name', 'Flow Recipient B',
      'date_of_birth', '1990-01-01', 'gender', 'male',
      'phone', '0555000003', 'blood_type', 'O+', 'city', 'Alger'
    )
  );

insert into public.hospitals (id, wilaya_id, name_ar)
values ('aaaaaaaa-0000-4000-8000-000000000001', 1, 'مستشفى الاختبار');

-- Request A + its accepted appointment (drives update + appointment-cancel).
insert into public.blood_requests
  (id, requested_by, hospital_name, hospital_id, city, wilaya_id, blood_type)
values
  ('a1111111-0000-4000-8000-00000000000a',
   '11111111-0000-4000-8000-000000000001', 'مستشفى الاختبار',
   'aaaaaaaa-0000-4000-8000-000000000001', 'Alger', 1, 'O+');

insert into public.appointments (id, donor_id, blood_request_id, scheduled_at, status)
values
  ('aa222222-0000-4000-8000-0000000000aa',
   '22222222-0000-4000-8000-000000000002',
   'a1111111-0000-4000-8000-00000000000a', now() + interval '2 days', 'confirmed');

-- 1. Recipient edits request A -> the accepted donor is notified. ------------
select set_config(
  'request.jwt.claims',
  json_build_object('sub', '11111111-0000-4000-8000-000000000001')::text,
  true
);
select public.update_blood_request(
  'a1111111-0000-4000-8000-00000000000a',
  'aaaaaaaa-0000-4000-8000-000000000001',
  'A+', 'urgent', 2, now() + interval '5 days', 'moved up'
);
select is(
  (
    select count(*)::bigint
    from public.notifications
    where user_id = '22222222-0000-4000-8000-000000000002'
      and ref_id = 'a1111111-0000-4000-8000-00000000000a'
      and type = 'request_update'
  ),
  1::bigint,
  'editing a request notifies the donor who accepted it'
);

-- 2. Donor cancels their appointment on A -> the recipient is notified. ------
select set_config(
  'request.jwt.claims',
  json_build_object('sub', '22222222-0000-4000-8000-000000000002')::text,
  true
);
select public.cancel_appointment(
  'aa222222-0000-4000-8000-0000000000aa', 'something came up'
);
select is(
  (
    select count(*)::bigint
    from public.notifications
    where user_id = '11111111-0000-4000-8000-000000000001'
      and ref_id = 'a1111111-0000-4000-8000-00000000000a'
      and type = 'request_update'
  ),
  1::bigint,
  'a donor cancelling their appointment notifies the recipient'
);

-- Request B + its appointment: created now that the donor's slot on A is free
-- (a donor may hold only one active appointment at a time).
insert into public.blood_requests
  (id, requested_by, hospital_name, hospital_id, city, wilaya_id, blood_type)
values
  ('b1111111-0000-4000-8000-00000000000b',
   '33333333-0000-4000-8000-000000000003', 'مستشفى الاختبار',
   'aaaaaaaa-0000-4000-8000-000000000001', 'Alger', 1, 'O+');

insert into public.appointments (id, donor_id, blood_request_id, scheduled_at, status)
values
  ('bb222222-0000-4000-8000-0000000000bb',
   '22222222-0000-4000-8000-000000000002',
   'b1111111-0000-4000-8000-00000000000b', now() + interval '2 days', 'confirmed');

-- 3. Recipient cancels request B -> the accepted donor is notified. ----------
select set_config(
  'request.jwt.claims',
  json_build_object('sub', '33333333-0000-4000-8000-000000000003')::text,
  true
);
select public.cancel_blood_request(
  'b1111111-0000-4000-8000-00000000000b', 'patient recovered'
);
select is(
  (
    select count(*)::bigint
    from public.notifications
    where user_id = '22222222-0000-4000-8000-000000000002'
      and ref_id = 'b1111111-0000-4000-8000-00000000000b'
      and type = 'request_update'
  ),
  1::bigint,
  'cancelling a request notifies the donor who accepted it'
);

-- 4. The donor's appointment on B was voided by the cancellation. ------------
select is(
  (
    select status::text
    from public.appointments
    where id = 'bb222222-0000-4000-8000-0000000000bb'
  ),
  'cancelled',
  'cancelling a request voids the accepted appointments'
);

select * from finish();
rollback;
