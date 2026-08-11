-- ============================================================
-- تبرع (Tabara3) — Initial Schema Migration
-- Database: Supabase (PostgreSQL + PostGIS)
-- Version: 2.0.0
-- ============================================================

-- ============================================================
-- EXTENSIONS
-- ============================================================
create extension if not exists postgis;
create extension if not exists "uuid-ossp";


-- ============================================================
-- ENUMS
-- ============================================================
create type blood_type_enum as enum (
  'A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-'
);

create type request_urgency_enum as enum (
  'urgent',
  'normal'
);

create type request_status_enum as enum (
  'open',
  'fulfilled',
  'cancelled',
  'expired'
);

create type campaign_status_enum as enum (
  'upcoming',
  'active',
  'completed',
  'cancelled'
);

create type appointment_status_enum as enum (
  'pending',
  'confirmed',
  'completed',
  'cancelled'
);

create type notification_type_enum as enum (
  'new_request',
  'new_campaign',
  'appointment_reminder',
  'participation_accepted',
  'thank_you'
);

create type point_reason_enum as enum (
  'donation',
  'on_time',
  'cancellation',
  'account_age',
  'assisted_donation'
);


-- ============================================================
-- USERS
-- ============================================================
create table users (
  id                    uuid                primary key
                                             references auth.users(id) on delete cascade,

  -- identity
  username              text                unique not null,
  full_name             text                not null,
  date_of_birth         date                not null,
  gender                text                not null check (gender in ('male', 'female')),
  avatar_url            text,

  -- contact
  phone                 text                not null,
  email                 text,

  -- roles (boolean flags — not mutually exclusive)
  is_donor              boolean             not null default false,
  is_recipient          boolean             not null default false,
  is_admin              boolean             not null default false,

  -- blood (required at signup)
  blood_type            blood_type_enum     not null,
  blood_type_verified   boolean             not null default false,

  -- location
  city                  text                not null,
  district              text,
  location              geometry(Point, 4326),

  -- push notifications
  fcm_token             text,

  -- gamification cache (updated via triggers)
  total_points          int                 not null default 0,
  total_donations_count int                 not null default 0,
  last_donation_date    date,

  -- timestamps
  created_at            timestamptz         not null default now(),
  updated_at            timestamptz         not null default now(),
  deleted_at            timestamptz,

  constraint at_least_one_role check (
    is_donor or is_recipient
  )
);


-- ============================================================
-- BLOOD REQUESTS
-- ============================================================
create table blood_requests (
  id              uuid                  primary key default gen_random_uuid(),
  requested_by    uuid                  not null references users(id) on delete cascade,
  hospital_name   text                  not null,
  city            text                  not null,
  district        text,
  location        geometry(Point, 4326),
  blood_type      blood_type_enum       not null,
  urgency         request_urgency_enum  not null default 'normal',
  units_needed    int                   not null default 1 check (units_needed > 0),
  units_fulfilled int                   not null default 0 check (units_fulfilled >= 0),
  status          request_status_enum   not null default 'open',
  notes           text,
  expires_at      timestamptz,
  created_at      timestamptz           not null default now(),
  updated_at      timestamptz           not null default now(),
  deleted_at      timestamptz
);


-- ============================================================
-- CAMPAIGNS
-- ============================================================
create table campaigns (
  id                  uuid                  primary key default gen_random_uuid(),
  created_by          uuid                  references users(id) on delete set null,
  organizer_name      text                  not null,
  title               text                  not null,
  description         text,
  venue_name          text,
  location            geometry(Point, 4326),
  city                text                  not null,
  district            text,
  starts_at           timestamptz           not null,
  ends_at             timestamptz           not null,
  max_donors          int,
  blood_types_needed  blood_type_enum[],
  status              campaign_status_enum  not null default 'upcoming',
  created_at          timestamptz           not null default now(),
  updated_at          timestamptz           not null default now(),
  deleted_at          timestamptz,
  constraint ends_after_starts check (ends_at > starts_at)
);


-- ============================================================
-- APPOINTMENTS
-- ============================================================
create table appointments (
  id                uuid                    primary key default gen_random_uuid(),
  donor_id          uuid                    not null references users(id) on delete cascade,
  blood_request_id  uuid                    references blood_requests(id) on delete cascade,
  campaign_id       uuid                    references campaigns(id) on delete cascade,
  scheduled_at      timestamptz             not null,
  status            appointment_status_enum not null default 'pending',
  created_at        timestamptz             not null default now(),
  updated_at        timestamptz             not null default now(),
  deleted_at        timestamptz,
  constraint exactly_one_ref check (
    (blood_request_id is not null)::int +
    (campaign_id      is not null)::int = 1
  ),
  constraint future_appointment check (scheduled_at > created_at)
);


-- ============================================================
-- POINT TRANSACTIONS
-- ============================================================
create table point_transactions (
  id          uuid              primary key default gen_random_uuid(),
  donor_id    uuid              not null references users(id) on delete cascade,
  amount      int               not null,
  reason      point_reason_enum not null,
  ref_id      uuid,
  ref_type    text check (
    ref_type is null or ref_type in ('appointment', 'referral')
  ),
  created_at  timestamptz       not null default now()
);


-- ============================================================
-- LEVELS
-- ============================================================
create table levels (
  level_number  int   primary key,
  min_points    int   not null unique,
  name_ar       text  not null,
  icon_url      text
);

insert into levels (level_number, min_points, name_ar) values
  (1,   0,   'قطرة أمل'),
  (2,   10,  'متبرع نشط'),
  (3,   50,  'متبرع ملتزم'),
  (4,   90,  'متبرع مميز'),
  (5,   120, 'تستحق جائزة');


-- ============================================================
-- BADGES
-- ============================================================
create table badges (
  id              uuid        primary key default gen_random_uuid(),
  name_ar         text        not null,
  name_en         text,
  description_ar  text,
  icon_url        text,
  condition_type  text        not null check (
    condition_type in ('points_threshold', 'donations_count', 'streak', 'manual')
  ),
  threshold       int,
  created_at      timestamptz not null default now(),
  updated_at      timestamptz not null default now()
);

create table user_badges (
  id          uuid        primary key default gen_random_uuid(),
  user_id     uuid        not null references users(id) on delete cascade,
  badge_id    uuid        not null references badges(id) on delete cascade,
  earned_at   timestamptz not null default now(),
  updated_at  timestamptz not null default now(),
  unique(user_id, badge_id)
);


-- ============================================================
-- NOTIFICATIONS
-- ============================================================
create table notifications (
  id          uuid                    primary key default gen_random_uuid(),
  user_id     uuid                    not null references users(id) on delete cascade,
  type        notification_type_enum  not null,
  title       text                    not null,
  body        text                    not null,
  ref_id      uuid,
  ref_type    text check (
    ref_type is null or ref_type in ('blood_request', 'campaign', 'appointment')
  ),
  is_read     boolean                 not null default false,
  created_at  timestamptz             not null default now(),
  updated_at  timestamptz             not null default now()
);


-- ============================================================
-- REFERRALS
-- ============================================================
create table referrals (
  id              uuid        primary key default gen_random_uuid(),
  referrer_id     uuid        not null references users(id) on delete cascade,
  referred_id     uuid        not null references users(id) on delete cascade,
  appointment_id  uuid        references appointments(id) on delete set null,
  points_credited boolean     not null default false,
  created_at      timestamptz not null default now(),
  updated_at      timestamptz not null default now(),
  constraint no_self_referral check (referrer_id != referred_id),
  unique(referrer_id, referred_id)
);


-- ============================================================
-- BLOOD TYPE COMPATIBILITY
-- ============================================================
create table blood_type_compatibility (
  donor_type      blood_type_enum not null,
  recipient_type  blood_type_enum not null,
  primary key (donor_type, recipient_type)
);

insert into blood_type_compatibility (donor_type, recipient_type) values
  ('O-',  'O-'), ('O-',  'O+'), ('O-',  'A-'), ('O-',  'A+'),
  ('O-',  'B-'), ('O-',  'B+'), ('O-',  'AB-'),('O-',  'AB+'),
  ('O+',  'O+'), ('O+',  'A+'), ('O+',  'B+'), ('O+',  'AB+'),
  ('A-',  'A-'), ('A-',  'A+'), ('A-',  'AB-'),('A-',  'AB+'),
  ('A+',  'A+'), ('A+',  'AB+'),
  ('B-',  'B-'), ('B-',  'B+'), ('B-',  'AB-'),('B-',  'AB+'),
  ('B+',  'B+'), ('B+',  'AB+'),
  ('AB-', 'AB-'),('AB-', 'AB+'),
  ('AB+', 'AB+');


-- ============================================================
-- VIEWS
-- ============================================================

create or replace view eligible_donors as
  select * from users
  where deleted_at is null
    and is_donor = true
    and date_of_birth <= current_date - interval '18 years'
    and (
      last_donation_date is null
      or last_donation_date < current_date - interval '90 days'
    );

create or replace view public_profiles as
  select
    id, username, full_name, avatar_url,
    blood_type, blood_type_verified,
    city, district,
    is_donor, is_recipient,
    total_points, total_donations_count,
    created_at
  from users
  where deleted_at is null;

create or replace function compatible_donors_for_request(p_request_id uuid)
returns table (
  donor_id  uuid,
  full_name text,
  blood_type blood_type_enum,
  city text,
  location geometry
) language sql stable as $$
  select
    u.id,
    u.full_name,
    u.blood_type,
    u.city,
    u.location
  from eligible_donors u
  join blood_type_compatibility c on c.donor_type = u.blood_type
  join blood_requests r on r.id = p_request_id
  where c.recipient_type = r.blood_type
    and r.deleted_at is null;
$$;


-- ============================================================
-- TRIGGER FUNCTIONS
-- ============================================================

create or replace function set_updated_at()
returns trigger language plpgsql as $$
begin
  new.updated_at = now();
  return new;
end;
$$;

create or replace function sync_total_points()
returns trigger language plpgsql as $$
begin
  if TG_OP = 'INSERT' then
    update users set total_points = total_points + NEW.amount
    where id = NEW.donor_id;
    return NEW;
  elsif TG_OP = 'UPDATE' then
    update users set total_points = total_points - OLD.amount
    where id = OLD.donor_id;
    update users set total_points = total_points + NEW.amount
    where id = NEW.donor_id;
    return NEW;
  elsif TG_OP = 'DELETE' then
    update users set total_points = total_points - OLD.amount
    where id = OLD.donor_id;
    return OLD;
  end if;
  return NULL;
end;
$$;

create or replace function on_appointment_completed()
returns trigger language plpgsql as $$
begin
  if NEW.status = 'completed' and OLD.status != 'completed' then

    update users set
      last_donation_date    = current_date,
      total_donations_count = total_donations_count + 1,
      updated_at            = now()
    where id = NEW.donor_id;

    if NEW.blood_request_id is not null then
      update blood_requests set
        units_fulfilled = units_fulfilled + 1,
        updated_at      = now()
      where id = NEW.blood_request_id;

      update blood_requests set
        status     = 'fulfilled',
        updated_at = now()
      where id = NEW.blood_request_id
        and units_fulfilled >= units_needed;
    end if;

  end if;
  return NEW;
end;
$$;


-- ============================================================
-- TRIGGERS
-- ============================================================

create trigger trg_users_updated_at
  before update on users
  for each row execute function set_updated_at();

create trigger trg_blood_requests_updated_at
  before update on blood_requests
  for each row execute function set_updated_at();

create trigger trg_campaigns_updated_at
  before update on campaigns
  for each row execute function set_updated_at();

create trigger trg_appointments_updated_at
  before update on appointments
  for each row execute function set_updated_at();

create trigger trg_badges_updated_at
  before update on badges
  for each row execute function set_updated_at();

create trigger trg_user_badges_updated_at
  before update on user_badges
  for each row execute function set_updated_at();

create trigger trg_notifications_updated_at
  before update on notifications
  for each row execute function set_updated_at();

create trigger trg_referrals_updated_at
  before update on referrals
  for each row execute function set_updated_at();

create trigger trg_sync_points
  after insert or update or delete on point_transactions
  for each row execute function sync_total_points();

create trigger trg_appointment_completed
  after update on appointments
  for each row execute function on_appointment_completed();


-- ============================================================
-- INDEXES
-- ============================================================

create index idx_users_location          on users          using gist (location);
create index idx_blood_requests_location on blood_requests  using gist (location);
create index idx_campaigns_location      on campaigns      using gist (location);

create index idx_users_blood_type
  on users (blood_type)
  where deleted_at is null;

create index idx_users_city
  on users (city)
  where deleted_at is null;

create index idx_users_donor_active
  on users (is_donor)
  where deleted_at is null and is_donor = true;

create index idx_blood_requests_status_type
  on blood_requests (status, blood_type)
  where deleted_at is null;

create index idx_blood_requests_city
  on blood_requests (city, status)
  where deleted_at is null;

create index idx_blood_requests_requested_by
  on blood_requests (requested_by)
  where deleted_at is null;

create index idx_blood_requests_expires_at
  on blood_requests (expires_at)
  where status = 'open' and deleted_at is null;

create index idx_campaigns_status_starts_at
  on campaigns (status, starts_at)
  where deleted_at is null;

create index idx_campaigns_created_by
  on campaigns (created_by)
  where deleted_at is null;

create index idx_appointments_donor
  on appointments (donor_id, status)
  where deleted_at is null;

create index idx_appointments_blood_request
  on appointments (blood_request_id, status)
  where deleted_at is null;

create index idx_appointments_campaign
  on appointments (campaign_id, status)
  where deleted_at is null;

create index idx_point_transactions_donor
  on point_transactions (donor_id, created_at desc);

create index idx_notifications_user
  on notifications (user_id, is_read, created_at desc);

create index idx_user_badges_user
  on user_badges (user_id);

create index idx_referrals_referrer
  on referrals (referrer_id);

create index idx_referrals_referred
  on referrals (referred_id);
