-- Behavioural proof that a completed donation lands in the donor's history and
-- notifies both sides. An eligible donor accepts a request, the recipient
-- issues a QR, the donor redeems it, and a donation_records row plus a
-- donation_confirmed notification result.

begin;

create extension if not exists pgtap with schema extensions;

select plan(3);

-- Fixtures -------------------------------------------------------------------
insert into auth.users (id, raw_user_meta_data)
values
  (
    '66666666-0000-4000-8000-000000000006',
    jsonb_build_object(
      'username', 'hist_recipient', 'full_name', 'History Recipient',
      'date_of_birth', '1990-01-01', 'gender', 'male',
      'phone', '0555000006', 'blood_type', 'O+', 'city', 'Alger'
    )
  ),
  (
    '77777777-0000-4000-8000-000000000007',
    jsonb_build_object(
      'username', 'hist_donor', 'full_name', 'History Donor',
      'date_of_birth', '1990-01-01', 'gender', 'male',
      'phone', '0555000007', 'blood_type', 'O+', 'city', 'Alger'
    )
  );

update public.users
set is_donor = true,
    is_available_for_donation = true,
    is_active = true,
    wilaya_id = 1,
    cooldown_until = null
where id = '77777777-0000-4000-8000-000000000007';

insert into public.hospitals (id, wilaya_id, name_ar)
values ('dddddddd-0000-4000-8000-000000000004', 1, 'مستشفى الاختبار');

insert into public.blood_requests
  (id, requested_by, hospital_name, hospital_id, city, wilaya_id, blood_type)
values
  ('d1111111-0000-4000-8000-00000000000d',
   '66666666-0000-4000-8000-000000000006', 'مستشفى الاختبار',
   'dddddddd-0000-4000-8000-000000000004', 'Alger', 1, 'O+');

-- Donor accepts the request. -------------------------------------------------
select set_config(
  'request.jwt.claims',
  json_build_object('sub', '77777777-0000-4000-8000-000000000007')::text,
  true
);
select public.accept_blood_request(
  'd1111111-0000-4000-8000-00000000000d', now() + interval '3 days'
);

-- Recipient issues a QR for the request. -------------------------------------
select set_config(
  'request.jwt.claims',
  json_build_object('sub', '66666666-0000-4000-8000-000000000006')::text,
  true
);
create temporary table _qr on commit drop as
select token from public.issue_request_qr('d1111111-0000-4000-8000-00000000000d');

-- Donor redeems the QR at the hospital. --------------------------------------
select set_config(
  'request.jwt.claims',
  json_build_object('sub', '77777777-0000-4000-8000-000000000007')::text,
  true
);
select public.redeem_request_qr((select token from _qr));

-- 1. The donation is recorded in the donor's history. ------------------------
select is(
  (
    select count(*)::bigint
    from public.donation_records
    where donor_id = '77777777-0000-4000-8000-000000000007'
      and request_id = 'd1111111-0000-4000-8000-00000000000d'
  ),
  1::bigint,
  'redeeming a request QR records the donation in the donor history'
);

-- 2. The appointment is marked completed. ------------------------------------
select is(
  (
    select status::text
    from public.appointments
    where blood_request_id = 'd1111111-0000-4000-8000-00000000000d'
      and donor_id = '77777777-0000-4000-8000-000000000007'
  ),
  'completed',
  'redeeming a request QR completes the appointment'
);

-- 3. The donor is notified their donation was confirmed. ---------------------
select is(
  (
    select count(*)::bigint
    from public.notifications
    where user_id = '77777777-0000-4000-8000-000000000007'
      and type = 'donation_confirmed'
  ),
  1::bigint,
  'the donor is notified when their donation is confirmed'
);

select * from finish();
rollback;
