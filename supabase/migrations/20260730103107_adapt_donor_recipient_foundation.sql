-- ============================================================
-- Tabara3 donor/recipient compatibility foundation
-- Keeps Supabase Auth UUID identities and evolves the empty
-- development application schema additively.
-- ============================================================

create type public.user_mode_enum as enum ('donor', 'recipient');
create type public.invitation_status_enum as enum (
  'sent',
  'accepted',
  'rejected',
  'expired',
  'cancelled'
);
create type public.qr_token_kind_enum as enum ('request', 'campaign');
create type public.donation_source_enum as enum ('request', 'campaign');

alter type public.request_urgency_enum
  add value if not exists 'semi_urgent' before 'urgent';

create table public.wilayas (
  id smallint primary key,
  code char(2) not null unique,
  name_ar text not null unique,
  name_fr text not null unique
);

insert into public.wilayas (id, code, name_ar, name_fr) values
  (1, '01', 'أدرار', 'Adrar'),
  (2, '02', 'الشلف', 'Chlef'),
  (3, '03', 'الأغواط', 'Laghouat'),
  (4, '04', 'أم البواقي', 'Oum El Bouaghi'),
  (5, '05', 'باتنة', 'Batna'),
  (6, '06', 'بجاية', 'Bejaia'),
  (7, '07', 'بسكرة', 'Biskra'),
  (8, '08', 'بشار', 'Bechar'),
  (9, '09', 'البليدة', 'Blida'),
  (10, '10', 'البويرة', 'Bouira'),
  (11, '11', 'تمنراست', 'Tamanrasset'),
  (12, '12', 'تبسة', 'Tebessa'),
  (13, '13', 'تلمسان', 'Tlemcen'),
  (14, '14', 'تيارت', 'Tiaret'),
  (15, '15', 'تيزي وزو', 'Tizi Ouzou'),
  (16, '16', 'الجزائر', 'Alger'),
  (17, '17', 'الجلفة', 'Djelfa'),
  (18, '18', 'جيجل', 'Jijel'),
  (19, '19', 'سطيف', 'Setif'),
  (20, '20', 'سعيدة', 'Saida'),
  (21, '21', 'سكيكدة', 'Skikda'),
  (22, '22', 'سيدي بلعباس', 'Sidi Bel Abbes'),
  (23, '23', 'عنابة', 'Annaba'),
  (24, '24', 'قالمة', 'Guelma'),
  (25, '25', 'قسنطينة', 'Constantine'),
  (26, '26', 'المدية', 'Medea'),
  (27, '27', 'مستغانم', 'Mostaganem'),
  (28, '28', 'المسيلة', 'M''Sila'),
  (29, '29', 'معسكر', 'Mascara'),
  (30, '30', 'ورقلة', 'Ouargla'),
  (31, '31', 'وهران', 'Oran'),
  (32, '32', 'البيض', 'El Bayadh'),
  (33, '33', 'إليزي', 'Illizi'),
  (34, '34', 'برج بوعريريج', 'Bordj Bou Arreridj'),
  (35, '35', 'بومرداس', 'Boumerdes'),
  (36, '36', 'الطارف', 'El Tarf'),
  (37, '37', 'تندوف', 'Tindouf'),
  (38, '38', 'تيسمسيلت', 'Tissemsilt'),
  (39, '39', 'الوادي', 'El Oued'),
  (40, '40', 'خنشلة', 'Khenchela'),
  (41, '41', 'سوق أهراس', 'Souk Ahras'),
  (42, '42', 'تيبازة', 'Tipaza'),
  (43, '43', 'ميلة', 'Mila'),
  (44, '44', 'عين الدفلى', 'Ain Defla'),
  (45, '45', 'النعامة', 'Naama'),
  (46, '46', 'عين تموشنت', 'Ain Temouchent'),
  (47, '47', 'غرداية', 'Ghardaia'),
  (48, '48', 'غليزان', 'Relizane'),
  (49, '49', 'تيميمون', 'Timimoun'),
  (50, '50', 'برج باجي مختار', 'Bordj Badji Mokhtar'),
  (51, '51', 'أولاد جلال', 'Ouled Djellal'),
  (52, '52', 'بني عباس', 'Beni Abbes'),
  (53, '53', 'عين صالح', 'In Salah'),
  (54, '54', 'عين قزام', 'In Guezzam'),
  (55, '55', 'تقرت', 'Touggourt'),
  (56, '56', 'جانت', 'Djanet'),
  (57, '57', 'المغير', 'El M''Ghair'),
  (58, '58', 'المنيعة', 'El Meniaa'),
  (59, '59', 'آفلو', 'Aflou'),
  (60, '60', 'بريكة', 'Barika'),
  (61, '61', 'القنطرة', 'El Kantara'),
  (62, '62', 'بئر العاتر', 'Bir El Ater'),
  (63, '63', 'العريشة', 'El Aricha'),
  (64, '64', 'قصر الشلالة', 'Ksar Chellala'),
  (65, '65', 'عين وسارة', 'Ain Oussera'),
  (66, '66', 'مسعد', 'Messaad'),
  (67, '67', 'قصر البخاري', 'Ksar El Boukhari'),
  (68, '68', 'بوسعادة', 'Bou Saada'),
  (69, '69', 'الأبيض سيدي الشيخ', 'El Abiodh Sidi Cheikh')
on conflict (id) do update set
  code = excluded.code,
  name_ar = excluded.name_ar,
  name_fr = excluded.name_fr;

create table public.hospitals (
  id uuid primary key default extensions.uuid_generate_v4(),
  wilaya_id smallint not null references public.wilayas(id),
  name_ar text not null,
  name_fr text,
  address text,
  latitude numeric(10, 7),
  longitude numeric(10, 7),
  phone text,
  is_active boolean not null default true,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  unique (wilaya_id, name_ar)
);

create table public.associations (
  id uuid primary key default extensions.uuid_generate_v4(),
  wilaya_id smallint not null references public.wilayas(id),
  name_ar text not null,
  name_fr text,
  contact_phone text,
  contact_email text,
  address text,
  description text,
  is_active boolean not null default true,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  unique (wilaya_id, name_ar)
);

create table public.chronic_diseases (
  id uuid primary key default extensions.uuid_generate_v4(),
  name_ar text not null unique,
  name_fr text,
  blocks_donation boolean not null default false,
  rule_source text,
  reviewed_at timestamptz,
  is_active boolean not null default true,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  constraint blocking_rule_requires_review check (
    not blocks_donation
    or (rule_source is not null and reviewed_at is not null)
  )
);

alter table public.users
  add column active_mode public.user_mode_enum,
  add column wilaya_id smallint references public.wilayas(id),
  add column cooldown_until date;

update public.users u
set wilaya_id = w.id
from public.wilayas w
where u.wilaya_id is null
  and btrim(u.city) = w.name_ar;

update public.users
set active_mode = case
  when is_recipient then 'recipient'::public.user_mode_enum
  when is_donor then 'donor'::public.user_mode_enum
  else null
end
where active_mode is null;

create table public.user_chronic_diseases (
  user_id uuid not null references public.users(id) on delete cascade,
  disease_id uuid not null references public.chronic_diseases(id),
  note text,
  created_at timestamptz not null default now(),
  primary key (user_id, disease_id)
);

alter table public.blood_requests
  add column hospital_id uuid references public.hospitals(id),
  add column wilaya_id smallint references public.wilayas(id),
  add column needed_by timestamptz;

update public.blood_requests r
set wilaya_id = w.id
from public.wilayas w
where r.wilaya_id is null
  and btrim(r.city) = w.name_ar;

alter table public.campaigns
  add column association_id uuid references public.associations(id),
  add column hospital_id uuid references public.hospitals(id),
  add column wilaya_id smallint references public.wilayas(id),
  add column published_at timestamptz;

update public.campaigns c
set wilaya_id = w.id
from public.wilayas w
where c.wilaya_id is null
  and btrim(c.city) = w.name_ar;

alter table public.appointments
  add column completed_at timestamptz,
  add column cancelled_at timestamptz,
  add column cancel_reason text;

create table public.direct_invitations (
  id uuid primary key default extensions.uuid_generate_v4(),
  request_id uuid not null
    references public.blood_requests(id) on delete cascade,
  donor_id uuid not null references public.users(id) on delete cascade,
  status public.invitation_status_enum not null default 'sent',
  appointment_id uuid references public.appointments(id) on delete set null,
  expires_at timestamptz not null default (now() + interval '24 hours'),
  responded_at timestamptz,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  constraint invitation_expiry_after_creation check (expires_at > created_at)
);

create table public.qr_tokens (
  id uuid primary key default extensions.uuid_generate_v4(),
  kind public.qr_token_kind_enum not null,
  token_hash text not null,
  request_id uuid references public.blood_requests(id) on delete cascade,
  campaign_id uuid references public.campaigns(id) on delete cascade,
  issued_by uuid not null references public.users(id) on delete cascade,
  expires_at timestamptz not null,
  consumed_at timestamptz,
  consumed_by uuid references public.users(id) on delete set null,
  created_at timestamptz not null default now(),
  constraint qr_exactly_one_subject check (
    num_nonnulls(request_id, campaign_id) = 1
  ),
  constraint qr_kind_matches_subject check (
    (kind = 'request' and request_id is not null and campaign_id is null)
    or
    (kind = 'campaign' and campaign_id is not null and request_id is null)
  ),
  constraint qr_expiry_after_creation check (expires_at > created_at),
  constraint qr_consumption_is_complete check (
    (consumed_at is null and consumed_by is null)
    or
    (consumed_at is not null and consumed_by is not null)
  )
);

create table public.donation_records (
  id uuid primary key default extensions.uuid_generate_v4(),
  donor_id uuid not null references public.users(id) on delete cascade,
  source public.donation_source_enum not null,
  request_id uuid references public.blood_requests(id) on delete set null,
  campaign_id uuid references public.campaigns(id) on delete set null,
  appointment_id uuid references public.appointments(id) on delete set null,
  hospital_id uuid references public.hospitals(id) on delete set null,
  donated_at timestamptz not null default now(),
  units smallint not null default 1 check (units > 0),
  created_at timestamptz not null default now(),
  constraint donation_source_matches_reference check (
    (
      source = 'request'
      and request_id is not null
      and campaign_id is null
      and appointment_id is not null
    )
    or
    (
      source = 'campaign'
      and campaign_id is not null
      and request_id is null
      and appointment_id is null
    )
  )
);

create table public.identity_corrections (
  id uuid primary key default extensions.uuid_generate_v4(),
  user_id uuid not null references public.users(id) on delete cascade,
  corrected_by uuid not null references public.users(id) on delete restrict,
  field_name text not null check (field_name in ('full_name', 'national_id')),
  old_value text,
  new_value text not null,
  reason text not null,
  corrected_at timestamptz not null default now(),
  constraint correction_changes_value check (
    old_value is distinct from new_value
  )
);

create unique index uq_blood_requests_one_active_per_recipient
  on public.blood_requests (requested_by)
  where status = 'open' and deleted_at is null;

create unique index uq_appointments_one_pending_per_donor
  on public.appointments (donor_id)
  where status in ('pending', 'confirmed') and deleted_at is null;

create unique index uq_direct_invitations_pending
  on public.direct_invitations (request_id, donor_id)
  where status = 'sent';

create unique index uq_qr_tokens_token_hash
  on public.qr_tokens (token_hash);

create unique index uq_donation_records_appointment
  on public.donation_records (appointment_id)
  where appointment_id is not null;

create unique index uq_donation_records_campaign_donor
  on public.donation_records (campaign_id, donor_id)
  where campaign_id is not null;

create index idx_hospitals_wilaya_active
  on public.hospitals (wilaya_id, name_ar)
  where is_active;

create index idx_associations_wilaya_active
  on public.associations (wilaya_id, name_ar)
  where is_active;

create index idx_direct_invitations_donor_status
  on public.direct_invitations (donor_id, status, expires_at);

create index idx_qr_tokens_request_active
  on public.qr_tokens (request_id, expires_at)
  where consumed_at is null;

create index idx_qr_tokens_campaign_active
  on public.qr_tokens (campaign_id, expires_at)
  where consumed_at is null;

create index idx_donation_records_donor_date
  on public.donation_records (donor_id, donated_at desc);

alter table public.wilayas enable row level security;
alter table public.hospitals enable row level security;
alter table public.associations enable row level security;
alter table public.chronic_diseases enable row level security;
alter table public.user_chronic_diseases enable row level security;
alter table public.direct_invitations enable row level security;
alter table public.qr_tokens enable row level security;
alter table public.donation_records enable row level security;
alter table public.identity_corrections enable row level security;

create policy wilayas_select_authenticated
  on public.wilayas
  for select
  to authenticated
  using (true);

create policy hospitals_select_active_authenticated
  on public.hospitals
  for select
  to authenticated
  using (is_active);

create policy associations_select_active_authenticated
  on public.associations
  for select
  to authenticated
  using (is_active);

create policy chronic_diseases_select_active_authenticated
  on public.chronic_diseases
  for select
  to authenticated
  using (is_active);

grant select on table
  public.wilayas,
  public.hospitals,
  public.associations,
  public.chronic_diseases
to authenticated;

revoke all on table
  public.user_chronic_diseases,
  public.direct_invitations,
  public.qr_tokens,
  public.donation_records,
  public.identity_corrections
from anon, authenticated;
