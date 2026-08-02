-- ============================================================
-- Tabara3 — TEST-ONLY seed data
-- Run in Supabase Dashboard → SQL Editor (runs as postgres).
-- Idempotent: safe to re-run. Dev/test data only — NOT for prod.
--
-- What it seeds:
--   1. Hospitals, associations, chronic diseases (admin reference data)
--   2. Campaigns (upcoming / active / completed)
--   3. Badges
--   4. Per EXISTING user (from public.users):
--      - recipients: one open blood request (if none open)
--      - donors: past campaign donation records + points + badge
--      - donors: pending appointment on upcoming campaign (if none pending)
--      - direct invitations from open requests to compatible donors
--      - notifications (mixed read/unread, all types)
-- ============================================================

begin;

-- ------------------------------------------------------------
-- 1) HOSPITALS (admin reference data)
-- ------------------------------------------------------------
insert into public.hospitals (id, wilaya_id, name_ar, name_fr, address, latitude, longitude, phone, is_active) values
  ('11111111-0000-4000-8000-000000000001', 16, 'مستشفى مصطفى باشا الجامعي', 'CHU Mustapha Pacha', 'Place du 1er Mai, Alger', 36.7590000, 3.0530000, '021235555', true),
  ('11111111-0000-4000-8000-000000000002', 16, 'مستشفى بني مسوس', 'CHU Beni Messous', 'Beni Messous, Alger', 36.7790000, 2.9750000, '021931111', true),
  ('11111111-0000-4000-8000-000000000003', 31, 'مستشفى وهران الجامعي', 'CHU Oran', 'Boulevard Benzerdjeb, Oran', 35.6970000, -0.6330000, '041412222', true),
  ('11111111-0000-4000-8000-000000000004', 25, 'مستشفى قسنطينة الجامعي', 'CHU Constantine', 'Boulevard Ben Badis, Constantine', 36.3650000, 6.6140000, '031643333', true),
  ('11111111-0000-4000-8000-000000000005', 9,  'مستشفى فرانتز فانون', 'Hopital Frantz Fanon', 'Blida centre', 36.4700000, 2.8280000, '025414444', true),
  ('11111111-0000-4000-8000-000000000006', 19, 'مستشفى سطيف الجامعي', 'CHU Setif', 'Setif centre', 36.1910000, 5.4130000, '036935555', true),
  ('11111111-0000-4000-8000-000000000007', 23, 'مستشفى ابن رشد عنابة', 'CHU Ibn Rochd Annaba', 'Annaba centre', 36.9000000, 7.7660000, '038866666', true),
  ('11111111-0000-4000-8000-000000000008', 15, 'مستشفى تيزي وزو الجامعي', 'CHU Tizi Ouzou', 'Tizi Ouzou centre', 36.7110000, 4.0450000, '026217777', true)
on conflict (wilaya_id, name_ar) do update set
  name_fr = excluded.name_fr,
  address = excluded.address,
  latitude = excluded.latitude,
  longitude = excluded.longitude,
  phone = excluded.phone,
  is_active = true;

-- ------------------------------------------------------------
-- 2) ASSOCIATIONS (admin reference data)
-- ------------------------------------------------------------
insert into public.associations (id, wilaya_id, name_ar, name_fr, contact_phone, contact_email, address, description, is_active) values
  ('22222222-0000-4000-8000-000000000001', 16, 'جمعية قطرة دم', 'Association Goutte de Sang', '0550101010', 'contact@goutte-sang.dz', 'Alger centre', 'جمعية وطنية للتبرع بالدم', true),
  ('22222222-0000-4000-8000-000000000002', 31, 'جمعية البركة للتبرع', 'Association El Baraka', '0550202020', 'contact@baraka-don.dz', 'Oran centre', 'جمعية خيرية لتنظيم حملات التبرع', true),
  ('22222222-0000-4000-8000-000000000003', 25, 'جمعية شريان الحياة', 'Association Artere de Vie', '0550303030', 'contact@chiryan.dz', 'Constantine centre', 'جمعية لدعم بنوك الدم', true)
on conflict (wilaya_id, name_ar) do update set
  name_fr = excluded.name_fr,
  contact_phone = excluded.contact_phone,
  is_active = true;

-- ------------------------------------------------------------
-- 3) CHRONIC DISEASES (admin reference data)
-- ------------------------------------------------------------
insert into public.chronic_diseases (id, name_ar, name_fr, blocks_donation, rule_source, reviewed_at, is_active) values
  ('33333333-0000-4000-8000-000000000001', 'ارتفاع ضغط الدم', 'Hypertension', false, null, null, true),
  ('33333333-0000-4000-8000-000000000002', 'السكري (النوع الثاني)', 'Diabete type 2', false, null, null, true),
  ('33333333-0000-4000-8000-000000000003', 'الربو', 'Asthme', false, null, null, true),
  ('33333333-0000-4000-8000-000000000004', 'التهاب الكبد ب', 'Hepatite B', true, 'WHO blood donor selection guidelines (test seed)', now(), true),
  ('33333333-0000-4000-8000-000000000005', 'أمراض القلب', 'Maladies cardiaques', true, 'WHO blood donor selection guidelines (test seed)', now(), true)
on conflict (name_ar) do update set
  name_fr = excluded.name_fr,
  blocks_donation = excluded.blocks_donation,
  rule_source = excluded.rule_source,
  reviewed_at = excluded.reviewed_at,
  is_active = true;

-- ------------------------------------------------------------
-- 4) CAMPAIGNS (admin-created; created_by null)
-- ------------------------------------------------------------
insert into public.campaigns (id, created_by, organizer_name, title, description, venue_name, city, district, wilaya_id, association_id, hospital_id, starts_at, ends_at, max_donors, blood_types_needed, status, published_at) values
  -- upcoming
  ('44444444-0000-4000-8000-000000000001', null, 'جمعية قطرة دم', 'حملة التبرع الكبرى — الجزائر', 'حملة تبرع بالدم بالتنسيق مع مستشفى مصطفى باشا. كل قطرة تنقذ حياة.', 'ساحة أول ماي', 'الجزائر', 'سيدي امحمد', 16, '22222222-0000-4000-8000-000000000001', '11111111-0000-4000-8000-000000000001', now() + interval '5 days', now() + interval '5 days 8 hours', 100, array['O-','O+','A+','B+']::blood_type_enum[], 'upcoming', now()),
  ('44444444-0000-4000-8000-000000000002', null, 'جمعية البركة للتبرع', 'قافلة الدم — وهران', 'قافلة تبرع متنقلة عبر أحياء وهران.', 'حي السلام', 'وهران', 'السانية', 31, '22222222-0000-4000-8000-000000000002', '11111111-0000-4000-8000-000000000003', now() + interval '10 days', now() + interval '10 days 6 hours', 60, array['O-','AB+']::blood_type_enum[], 'upcoming', now()),
  -- active now
  ('44444444-0000-4000-8000-000000000003', null, 'جمعية شريان الحياة', 'أسبوع التبرع — قسنطينة', 'أسبوع مفتوح للتبرع بالدم بمستشفى قسنطينة الجامعي.', 'المستشفى الجامعي', 'قسنطينة', 'وسط المدينة', 25, '22222222-0000-4000-8000-000000000003', '11111111-0000-4000-8000-000000000004', now() - interval '1 day', now() + interval '4 days', 200, null, 'active', now() - interval '3 days'),
  -- completed (history)
  ('44444444-0000-4000-8000-000000000004', null, 'جمعية قطرة دم', 'حملة رمضان الخيرية', 'حملة تبرع سنوية خلال شهر رمضان.', 'قاعة المؤتمرات', 'الجزائر', 'باب الوادي', 16, '22222222-0000-4000-8000-000000000001', '11111111-0000-4000-8000-000000000002', now() - interval '120 days', now() - interval '119 days 16 hours', 150, null, 'completed', now() - interval '130 days'),
  ('44444444-0000-4000-8000-000000000005', null, 'جمعية البركة للتبرع', 'يوم المتبرع العالمي', 'فعالية بمناسبة اليوم العالمي للتبرع بالدم.', 'دار الشباب', 'وهران', 'وسط المدينة', 31, '22222222-0000-4000-8000-000000000002', '11111111-0000-4000-8000-000000000003', now() - interval '45 days', now() - interval '44 days 18 hours', 80, null, 'completed', now() - interval '50 days')
on conflict (id) do update set
  title = excluded.title,
  starts_at = excluded.starts_at,
  ends_at = excluded.ends_at,
  status = excluded.status;

-- ------------------------------------------------------------
-- 5) BADGES
-- ------------------------------------------------------------
insert into public.badges (id, name_ar, name_en, description_ar, condition_type, threshold) values
  ('55555555-0000-4000-8000-000000000001', 'أول تبرع', 'First Donation', 'أتممت أول تبرع بالدم', 'donations_count', 1),
  ('55555555-0000-4000-8000-000000000002', 'متبرع دائم', 'Regular Donor', 'أتممت خمس تبرعات', 'donations_count', 5),
  ('55555555-0000-4000-8000-000000000003', 'مئة نقطة', 'Century', 'جمعت مئة نقطة', 'points_threshold', 100)
on conflict (id) do update set
  name_ar = excluded.name_ar,
  threshold = excluded.threshold;

-- ------------------------------------------------------------
-- 6) PER-EXISTING-USER DATA (dynamic)
-- ------------------------------------------------------------
do $$
declare
  u record;
  d record;
  r record;
  v_hospital_id uuid;
  v_hospital_name text;
  v_request_id uuid;
begin
  -- ---- 6a) One open blood request per recipient user (if none open)
  for u in
    select * from public.users
    where deleted_at is null
      and is_recipient
  loop
    if not exists (
      select 1 from public.blood_requests
      where requested_by = u.id and status = 'open' and deleted_at is null
    ) then
      -- pick a hospital in the user's wilaya, else default to Alger CHU
      select h.id, h.name_ar into v_hospital_id, v_hospital_name
      from public.hospitals h
      where h.is_active and h.wilaya_id = coalesce(u.wilaya_id, 16)
      order by h.name_ar limit 1;

      if v_hospital_id is null then
        v_hospital_id := '11111111-0000-4000-8000-000000000001';
        v_hospital_name := 'مستشفى مصطفى باشا الجامعي';
      end if;

      insert into public.blood_requests
        (requested_by, hospital_id, hospital_name, city, district, wilaya_id,
         blood_type, urgency, units_needed, status, notes, needed_by, expires_at)
      values
        (u.id, v_hospital_id, v_hospital_name, u.city, u.district,
         coalesce(u.wilaya_id, 16), u.blood_type, 'urgent', 3, 'open',
         'حالة مستعجلة — عملية جراحية مبرمجة (بيانات تجريبية)',
         now() + interval '3 days', now() + interval '3 days');
    end if;
  end loop;

  -- ---- 6b) Donor history: completed campaign donations + points + badge
  for u in
    select * from public.users
    where deleted_at is null and is_donor
  loop
    -- donation from Ramadan campaign (120 days ago) — outside 90-day cooldown
    insert into public.donation_records
      (donor_id, source, campaign_id, hospital_id, donated_at, units)
    values
      (u.id, 'campaign', '44444444-0000-4000-8000-000000000004',
       '11111111-0000-4000-8000-000000000002', now() - interval '120 days', 1)
    on conflict (campaign_id, donor_id) where campaign_id is not null do nothing;

    -- keep donor eligible: last donation 120 days ago (> 90-day cooldown)
    update public.users
    set last_donation_date = (now() - interval '120 days')::date,
        total_donations_count = greatest(total_donations_count, 1)
    where id = u.id and last_donation_date is null;

    -- points for that donation (trigger syncs total_points)
    if not exists (
      select 1 from public.point_transactions
      where donor_id = u.id and reason = 'donation'
        and ref_type is null and ref_id = '44444444-0000-4000-8000-000000000004'
    ) then
      insert into public.point_transactions (donor_id, amount, reason, ref_id, ref_type, created_at)
      values (u.id, 10, 'donation', '44444444-0000-4000-8000-000000000004', null, now() - interval '120 days');
    end if;

    -- first-donation badge
    insert into public.user_badges (user_id, badge_id, earned_at)
    values (u.id, '55555555-0000-4000-8000-000000000001', now() - interval '120 days')
    on conflict (user_id, badge_id) do nothing;

    -- pending appointment on the upcoming Alger campaign (one pending max per donor)
    if not exists (
      select 1 from public.appointments
      where donor_id = u.id and status in ('pending', 'confirmed') and deleted_at is null
    ) then
      insert into public.appointments (donor_id, campaign_id, scheduled_at, status)
      values (u.id, '44444444-0000-4000-8000-000000000001', now() + interval '5 days 2 hours', 'pending');
    end if;
  end loop;

  -- ---- 6c) Direct invitations: each open request → compatible donors (not self)
  for r in
    select br.* from public.blood_requests br
    where br.status = 'open' and br.deleted_at is null
  loop
    for d in
      select u2.id
      from public.users u2
      join public.blood_type_compatibility c
        on c.donor_type = u2.blood_type and c.recipient_type = r.blood_type
      where u2.deleted_at is null
        and u2.is_donor
        and u2.id <> r.requested_by
      limit 3
    loop
      if not exists (
        select 1 from public.direct_invitations
        where request_id = r.id and donor_id = d.id
      ) then
        insert into public.direct_invitations (request_id, donor_id, status, expires_at)
        values (r.id, d.id, 'sent', now() + interval '24 hours');

        insert into public.notifications (user_id, type, title, body, ref_id, ref_type, is_read)
        values (d.id, 'new_request', 'دعوة تبرع مباشرة',
                'تمت دعوتك للتبرع لطلب دم متوافق مع فصيلتك — ' || r.hospital_name,
                r.id, 'blood_request', false);
      end if;
    end loop;
  end loop;

  -- ---- 6d) General notifications for every user (skip if already seeded)
  for u in
    select * from public.users where deleted_at is null
  loop
    if not exists (
      select 1 from public.notifications
      where user_id = u.id and type = 'new_campaign'
        and ref_id = '44444444-0000-4000-8000-000000000001'
    ) then
      insert into public.notifications (user_id, type, title, body, ref_id, ref_type, is_read, created_at) values
        (u.id, 'new_campaign', 'حملة جديدة بالقرب منك',
         'حملة التبرع الكبرى — الجزائر تنطلق قريبا. سجل الآن!',
         '44444444-0000-4000-8000-000000000001', 'campaign', false, now() - interval '2 hours'),
        (u.id, 'thank_you', 'شكرا لك',
         'شكرا لمساهمتك في إنقاذ الأرواح. كل قطرة دم تصنع فرقا.',
         null, null, true, now() - interval '3 days');
    end if;

    if u.is_donor and not exists (
      select 1 from public.notifications
      where user_id = u.id and type = 'appointment_reminder'
    ) then
      insert into public.notifications (user_id, type, title, body, ref_type, is_read, created_at)
      values (u.id, 'appointment_reminder', 'تذكير بالموعد',
              'لديك موعد تبرع قادم ضمن حملة التبرع الكبرى — الجزائر.',
              null, false, now() - interval '1 hour');
    end if;
  end loop;
end;
$$;

commit;

-- ------------------------------------------------------------
-- Verify
-- ------------------------------------------------------------
select 'hospitals' as tbl, count(*) from public.hospitals
union all select 'associations', count(*) from public.associations
union all select 'chronic_diseases', count(*) from public.chronic_diseases
union all select 'campaigns', count(*) from public.campaigns
union all select 'badges', count(*) from public.badges
union all select 'blood_requests(open)', count(*) from public.blood_requests where status = 'open'
union all select 'appointments', count(*) from public.appointments
union all select 'direct_invitations', count(*) from public.direct_invitations
union all select 'donation_records', count(*) from public.donation_records
union all select 'point_transactions', count(*) from public.point_transactions
union all select 'user_badges', count(*) from public.user_badges
union all select 'notifications', count(*) from public.notifications
order by 1;
