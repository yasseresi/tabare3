-- Demo data for exercising the donor and recipient screens end to end.
--
-- Everything created here uses the `22222222-…` UUID prefix so it can be
-- identified and removed again, e.g.
--
--   delete from public.blood_requests where id::text like '22222222-%';
--
-- The script is idempotent: re-running it refreshes the same rows.
--
-- Note on volume: `uq_blood_requests_one_active_per_recipient` allows a single
-- open request per account, so the donor feed can only ever show one card per
-- other recipient. Seeding a busier feed means adding more accounts through
-- normal signup — this script deliberately does not create auth users.

-- ---------------------------------------------------------------------------
-- Hospitals — the demo accounts live in Sétif (wilaya 19), which only had one
-- hospital, so every request card named the same place.
-- ---------------------------------------------------------------------------
insert into public.hospitals (id, wilaya_id, name_ar, name_fr, address, is_active)
values
  ('22222222-0000-4000-8000-000000000001', 19, 'مستشفى سعادنة عبد النور',
   'CHU Saadna Abdenour', 'Sétif, El Bez', true),
  ('22222222-0000-4000-8000-000000000002', 19, 'المؤسسة الاستشفائية العيادات',
   'EPH Sétif', 'Sétif centre-ville', true)
on conflict (id) do update
  set name_ar = excluded.name_ar,
      name_fr = excluded.name_fr,
      address = excluded.address,
      is_active = excluded.is_active;

-- ---------------------------------------------------------------------------
-- Accounts — the primary demo account needs both roles so it can switch
-- between the donor and recipient shells, and the second account has to sit in
-- the same wilaya with a compatible blood type for its request to reach the
-- donor feed (O+ donors can give to A+, B+, AB+ and O+).
-- ---------------------------------------------------------------------------
update public.users
set is_donor = true,
    is_recipient = true,
    is_active = true,
    is_available_for_donation = true,
    cooldown_until = null,
    weight = coalesce(weight, 78),
    national_id = coalesce(national_id, '109876543210')
where email = 'yasser@tabara3.dz';

update public.users
set is_donor = true,
    is_recipient = true,
    is_active = true,
    wilaya_id = 19,
    blood_type = 'A+',
    weight = coalesce(weight, 71),
    national_id = coalesce(national_id, '101234567890')
where email = 'testuser.tabara3@gmail.com';

-- ---------------------------------------------------------------------------
-- Requests raised by the *other* account. Only the open one reaches the demo
-- account's donor feed; the closed ones give that account a history.
-- ---------------------------------------------------------------------------
with other_user as (
  select id from public.users where email = 'testuser.tabara3@gmail.com'
)
insert into public.blood_requests (
  id, requested_by, hospital_id, hospital_name, city, wilaya_id,
  beneficiary_type, blood_type, urgency, units_needed, units_fulfilled,
  status, needed_by, expires_at, notes, created_at
)
select v.id, other_user.id, v.hospital_id, h.name_ar, 'سطيف', 19,
       v.beneficiary_type::public.beneficiary_type_enum,
       v.blood_type::public.blood_type_enum,
       v.urgency::public.request_urgency_enum,
       v.units_needed, v.units_fulfilled,
       v.status::public.request_status_enum,
       now() + (v.needed_in || ' days')::interval,
       now() + (v.needed_in || ' days')::interval,
       v.notes,
       now() - (v.created_days_ago || ' days')::interval
from other_user
cross join (values
  ('22222222-1000-4000-8000-000000000001'::uuid,
   '11111111-0000-4000-8000-000000000006'::uuid,
   'other', 'A+', 'urgent', 4, 1, 'open', 12, 2,
   'حالة نزيف حاد بعد عملية جراحية'),
  ('22222222-1000-4000-8000-000000000002'::uuid,
   '22222222-0000-4000-8000-000000000001'::uuid,
   'self', 'A+', 'semi_urgent', 3, 3, 'fulfilled', 20, 40,
   'مريض يخضع لجلسات غسيل الكلى'),
  ('22222222-1000-4000-8000-000000000003'::uuid,
   '22222222-0000-4000-8000-000000000002'::uuid,
   'other', 'A+', 'normal', 2, 0, 'cancelled', 30, 60,
   'تحضير لعملية مبرمجة تم تأجيلها')
) as v(id, hospital_id, beneficiary_type, blood_type, urgency,
       units_needed, units_fulfilled, status, needed_in, created_days_ago,
       notes)
join public.hospitals h on h.id = v.hospital_id
on conflict (id) do update
  set urgency = excluded.urgency,
      units_needed = excluded.units_needed,
      units_fulfilled = excluded.units_fulfilled,
      status = excluded.status,
      needed_by = excluded.needed_by,
      expires_at = excluded.expires_at,
      notes = excluded.notes;

-- ---------------------------------------------------------------------------
-- Requests raised by the demo account itself, so its own list screen has one
-- card per lifecycle state (its pre-existing request supplies the open one).
-- ---------------------------------------------------------------------------
with demo_user as (
  select id from public.users where email = 'yasser@tabara3.dz'
)
insert into public.blood_requests (
  id, requested_by, hospital_id, hospital_name, city, wilaya_id,
  beneficiary_type, blood_type, urgency, units_needed, units_fulfilled,
  status, needed_by, expires_at, notes, created_at
)
select v.id, demo_user.id, v.hospital_id, h.name_ar, 'سطيف', 19,
       v.beneficiary_type::public.beneficiary_type_enum,
       v.blood_type::public.blood_type_enum,
       v.urgency::public.request_urgency_enum,
       v.units_needed, v.units_fulfilled,
       v.status::public.request_status_enum,
       now() + (v.needed_in || ' days')::interval,
       now() + (v.needed_in || ' days')::interval,
       v.notes,
       now() - (v.created_days_ago || ' days')::interval
from demo_user
cross join (values
  ('22222222-2000-4000-8000-000000000001'::uuid,
   '22222222-0000-4000-8000-000000000001'::uuid,
   'other', 'O+', 'semi_urgent', 3, 3, 'fulfilled', 15, 34,
   'طلب لصالح الوالدة قبل العملية'),
  ('22222222-2000-4000-8000-000000000002'::uuid,
   '11111111-0000-4000-8000-000000000006'::uuid,
   'self', 'O+', 'normal', 2, 1, 'cancelled', 25, 21,
   'تم إلغاء الطلب بعد توفر متبرع مباشر')
) as v(id, hospital_id, beneficiary_type, blood_type, urgency,
       units_needed, units_fulfilled, status, needed_in, created_days_ago,
       notes)
join public.hospitals h on h.id = v.hospital_id
on conflict (id) do update
  set urgency = excluded.urgency,
      units_needed = excluded.units_needed,
      units_fulfilled = excluded.units_fulfilled,
      status = excluded.status,
      needed_by = excluded.needed_by,
      expires_at = excluded.expires_at,
      notes = excluded.notes;

-- ---------------------------------------------------------------------------
-- Patient snapshots. Every request carries one — for `self` requests it mirrors
-- the requester, for `other` requests it is the named relative shown as the
-- request card title.
-- ---------------------------------------------------------------------------
insert into public.request_patients (
  request_id, full_name, national_id, blood_type, weight,
  chronic_diseases, gender, date_of_birth
)
select r.id,
       coalesce(v.full_name, u.full_name),
       coalesce(v.national_id, u.national_id, '100000000000'),
       r.blood_type,
       coalesce(v.weight, u.weight, 70),
       coalesce(v.chronic_diseases, u.chronic_diseases),
       coalesce(v.gender, u.gender),
       coalesce(v.date_of_birth::date, u.date_of_birth)
from public.blood_requests r
join public.users u on u.id = r.requested_by
left join (values
  ('22222222-1000-4000-8000-000000000001'::uuid, 'علي بن محمد', '110000000001',
   68.0, null, 'male', '1988-03-12'),
  ('22222222-1000-4000-8000-000000000003'::uuid, 'سارة بلقاسم', '110000000003',
   59.0, 'ربو', 'female', '1996-11-02'),
  ('22222222-2000-4000-8000-000000000001'::uuid, 'فاطمة قرزان', '110000000005',
   64.0, 'ضغط الدم', 'female', '1961-02-18')
) as v(request_id, full_name, national_id, weight, chronic_diseases,
       gender, date_of_birth)
  on v.request_id = r.id
where r.id::text like '22222222-%'
on conflict (request_id) do update
  set full_name = excluded.full_name,
      national_id = excluded.national_id,
      blood_type = excluded.blood_type,
      weight = excluded.weight,
      chronic_diseases = excluded.chronic_diseases,
      gender = excluded.gender,
      date_of_birth = excluded.date_of_birth;

-- Requests created before the beneficiary snapshot existed need a backfill,
-- otherwise their cards have no title.
insert into public.request_patients (
  request_id, full_name, national_id, blood_type, weight,
  chronic_diseases, gender, date_of_birth
)
select r.id, u.full_name, coalesce(u.national_id, '100000000000'), r.blood_type,
       coalesce(u.weight, 70), u.chronic_diseases, u.gender, u.date_of_birth
from public.blood_requests r
join public.users u on u.id = r.requested_by
where r.id::text not like '22222222-%'
on conflict (request_id) do nothing;

-- ---------------------------------------------------------------------------
-- Donation history for the demo account. Both appointments are closed, which
-- keeps the donor feed unblocked — `compatible_requests_for_donor` returns
-- nothing while a pending or confirmed appointment exists — while still
-- filling the appointments and record screens.
-- ---------------------------------------------------------------------------
with demo_user as (
  select id from public.users where email = 'yasser@tabara3.dz'
)
insert into public.appointments (
  id, donor_id, blood_request_id, scheduled_at, status,
  completed_at, cancelled_at, cancel_reason, created_at
)
select v.id, demo_user.id, v.request_id,
       now() - (v.days_ago || ' days')::interval,
       v.status::public.appointment_status_enum,
       case when v.status = 'completed'
            then now() - (v.days_ago || ' days')::interval end,
       case when v.status = 'cancelled'
            then now() - (v.days_ago || ' days')::interval end,
       v.cancel_reason,
       now() - ((v.days_ago + 3) || ' days')::interval
from demo_user
cross join (values
  ('22222222-3000-4000-8000-000000000001'::uuid,
   '22222222-1000-4000-8000-000000000002'::uuid, 30, 'completed', null),
  ('22222222-3000-4000-8000-000000000002'::uuid,
   '22222222-1000-4000-8000-000000000003'::uuid, 12, 'cancelled',
   'ظرف طارئ منعني من الحضور')
) as v(id, request_id, days_ago, status, cancel_reason)
on conflict (id) do update
  set status = excluded.status,
      scheduled_at = excluded.scheduled_at,
      completed_at = excluded.completed_at,
      cancelled_at = excluded.cancelled_at,
      cancel_reason = excluded.cancel_reason;

with demo_user as (
  select id from public.users where email = 'yasser@tabara3.dz'
)
insert into public.donation_records (
  id, donor_id, source, request_id, appointment_id, hospital_id,
  donated_at, units
)
select '22222222-4000-4000-8000-000000000001'::uuid, demo_user.id,
       'request'::public.donation_source_enum,
       '22222222-1000-4000-8000-000000000002'::uuid,
       '22222222-3000-4000-8000-000000000001'::uuid,
       '22222222-0000-4000-8000-000000000001'::uuid,
       now() - interval '30 days', 1
from demo_user
on conflict (id) do update
  set donated_at = excluded.donated_at,
      units = excluded.units;

-- ---------------------------------------------------------------------------
-- Notifications — a mix of read and unread so the centre has something to show
-- and the unread state is exercised. `ref_type` is constrained to
-- blood_request / campaign / appointment.
-- ---------------------------------------------------------------------------
with demo_user as (
  select id from public.users where email = 'yasser@tabara3.dz'
)
insert into public.notifications (
  id, user_id, type, title, body, ref_id, ref_type, is_read, created_at
)
select v.id, demo_user.id, v.type::public.notification_type_enum,
       v.title, v.body, v.ref_id, v.ref_type, v.is_read,
       now() - (v.hours_ago || ' hours')::interval
from demo_user
cross join (values
  ('22222222-5000-4000-8000-000000000001'::uuid, 'new_request',
   'طلب تبرع عاجل بالقرب منك',
   'مريض في مستشفى سطيف الجامعي بحاجة إلى فصيلة A+ خلال 12 يوماً.',
   '22222222-1000-4000-8000-000000000001'::uuid, 'blood_request', false, 2),
  ('22222222-5000-4000-8000-000000000002'::uuid, 'participation_accepted',
   'تم قبول مشاركتك',
   'شكراً لك، تم تسجيل موعد تبرعك في مستشفى سعادنة عبد النور.',
   '22222222-3000-4000-8000-000000000001'::uuid, 'appointment', false, 26),
  ('22222222-5000-4000-8000-000000000003'::uuid, 'donation_confirmed',
   'تم تأكيد تبرعك',
   'تم تسجيل تبرعك بنجاح وإضافة النقاط إلى بطاقة المتبرع الخاصة بك.',
   '22222222-3000-4000-8000-000000000001'::uuid, 'appointment', true, 720),
  ('22222222-5000-4000-8000-000000000004'::uuid, 'request_update',
   'تحديث على طلبك',
   'تم توفير كيس دم جديد لطلبك في مستشفى سعادنة عبد النور.',
   '22222222-2000-4000-8000-000000000001'::uuid, 'blood_request', false, 5)
) as v(id, type, title, body, ref_id, ref_type, is_read, hours_ago)
on conflict (id) do update
  set title = excluded.title,
      body = excluded.body,
      is_read = excluded.is_read,
      created_at = excluded.created_at;

-- ---------------------------------------------------------------------------
-- Points, so the donor card shows a level and progress rather than zero.
-- `ref_type` here only accepts appointment / referral.
-- ---------------------------------------------------------------------------
with demo_user as (
  select id from public.users where email = 'yasser@tabara3.dz'
)
insert into public.point_transactions (
  id, donor_id, amount, reason, ref_id, ref_type, created_at
)
select v.id, demo_user.id, v.amount, v.reason::public.point_reason_enum,
       v.ref_id, v.ref_type, now() - (v.days_ago || ' days')::interval
from demo_user
cross join (values
  ('22222222-6000-4000-8000-000000000001'::uuid, 10, 'donation',
   '22222222-3000-4000-8000-000000000001'::uuid, 'appointment', 30),
  ('22222222-6000-4000-8000-000000000002'::uuid, 2, 'on_time',
   '22222222-3000-4000-8000-000000000001'::uuid, 'appointment', 30),
  ('22222222-6000-4000-8000-000000000003'::uuid, -5, 'cancellation',
   '22222222-3000-4000-8000-000000000002'::uuid, 'appointment', 12)
) as v(id, amount, reason, ref_id, ref_type, days_ago)
on conflict (id) do update
  set amount = excluded.amount,
      reason = excluded.reason;

update public.users
set total_donations_count = (
      select count(*) from public.donation_records d where d.donor_id = users.id
    ),
    last_donation_date = (
      select max(d.donated_at)::date
      from public.donation_records d where d.donor_id = users.id
    ),
    total_points = greatest(0, coalesce((
      select sum(p.amount)
      from public.point_transactions p where p.donor_id = users.id
    ), 0))
where email = 'yasser@tabara3.dz';
