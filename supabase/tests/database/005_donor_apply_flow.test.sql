-- Behavioural proof of the donor side: an eligible donor sees a compatible open
-- request, accepts it, and the recipient is notified. Covers the core
-- "donor receives requests and can apply" path plus its notification.

begin;

create extension if not exists pgtap with schema extensions;

select plan(3);

-- Fixtures -------------------------------------------------------------------
insert into auth.users (id, raw_user_meta_data)
values
  (
    '44444444-0000-4000-8000-000000000004',
    jsonb_build_object(
      'username', 'apply_recipient', 'full_name', 'Apply Recipient',
      'date_of_birth', '1990-01-01', 'gender', 'male',
      'phone', '0555000004', 'blood_type', 'O+', 'city', 'Alger'
    )
  ),
  (
    '55555555-0000-4000-8000-000000000005',
    jsonb_build_object(
      'username', 'apply_donor', 'full_name', 'Apply Donor',
      'date_of_birth', '1990-01-01', 'gender', 'male',
      'phone', '0555000005', 'blood_type', 'O+', 'city', 'Alger'
    )
  );

-- Make the donor fully eligible for the matching engine.
update public.users
set is_donor = true,
    is_available_for_donation = true,
    is_active = true,
    wilaya_id = 1,
    cooldown_until = null
where id = '55555555-0000-4000-8000-000000000005';

insert into public.hospitals (id, wilaya_id, name_ar)
values ('cccccccc-0000-4000-8000-000000000003', 1, 'مستشفى الاختبار');

-- An open, in-wilaya, blood-compatible request from the recipient.
insert into public.blood_requests
  (id, requested_by, hospital_name, hospital_id, city, wilaya_id, blood_type)
values
  ('c1111111-0000-4000-8000-00000000000c',
   '44444444-0000-4000-8000-000000000004', 'مستشفى الاختبار',
   'cccccccc-0000-4000-8000-000000000003', 'Alger', 1, 'O+');

-- 1. The donor's feed surfaces the compatible request. -----------------------
select set_config(
  'request.jwt.claims',
  json_build_object('sub', '55555555-0000-4000-8000-000000000005')::text,
  true
);
select ok(
  exists (
    select 1
    from public.compatible_requests_for_donor() f
    where f.id = 'c1111111-0000-4000-8000-00000000000c'
  ),
  'an eligible donor sees the compatible open request in their feed'
);

-- 2. The donor accepts it -> a confirmed appointment is created. -------------
select public.accept_blood_request(
  'c1111111-0000-4000-8000-00000000000c', now() + interval '3 days'
);
select is(
  (
    select status::text
    from public.appointments
    where blood_request_id = 'c1111111-0000-4000-8000-00000000000c'
      and donor_id = '55555555-0000-4000-8000-000000000005'
  ),
  'confirmed',
  'accepting a request creates a confirmed appointment for the donor'
);

-- 3. The recipient is notified that a donor accepted. ------------------------
select is(
  (
    select count(*)::bigint
    from public.notifications
    where user_id = '44444444-0000-4000-8000-000000000004'
      and ref_id = 'c1111111-0000-4000-8000-00000000000c'
      and type = 'participation_accepted'
  ),
  1::bigint,
  'the recipient is notified when a donor accepts their request'
);

select * from finish();
rollback;
