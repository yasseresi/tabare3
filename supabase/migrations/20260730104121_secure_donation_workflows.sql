-- ============================================================
-- Secure donor/recipient workflows
-- All lifecycle mutations are transactional RPCs.
-- ============================================================

alter type public.notification_type_enum
  add value if not exists 'invitation_received';
alter type public.notification_type_enum
  add value if not exists 'invitation_response';
alter type public.notification_type_enum
  add value if not exists 'request_update';
alter type public.notification_type_enum
  add value if not exists 'donation_confirmed';

alter table public.users
  add column is_available_for_donation boolean not null default true;

alter table public.blood_requests
  add column cancelled_at timestamptz,
  add column cancel_reason text;

drop function public.compatible_donors_for_request(uuid);

create or replace function public.compatible_donors_for_request(
  p_request_id uuid
)
returns table (
  donor_id uuid,
  full_name text,
  blood_type public.blood_type_enum,
  wilaya_id smallint,
  cooldown_until date
)
language plpgsql
stable
security definer
set search_path = pg_catalog, public, extensions
as $$
declare
  v_caller uuid := auth.uid();
begin
  if v_caller is null then
    raise exception using errcode = 'P0001', message = 'unauthenticated';
  end if;

  if not exists (
    select 1
    from public.blood_requests r
    where r.id = p_request_id
      and (r.requested_by = v_caller or public.is_admin())
      and r.status = 'open'
      and r.deleted_at is null
  ) then
    raise exception using errcode = 'P0001', message = 'request_not_accessible';
  end if;

  return query
  select
    u.id,
    u.full_name,
    u.blood_type,
    u.wilaya_id,
    u.cooldown_until
  from public.users u
  join public.blood_requests r on r.id = p_request_id
  join public.blood_type_compatibility c
    on c.donor_type = u.blood_type
   and c.recipient_type = r.blood_type
  where u.deleted_at is null
    and u.is_active
    and u.is_donor
    and u.is_available_for_donation
    and u.id <> r.requested_by
    and u.wilaya_id = r.wilaya_id
    and u.date_of_birth <= current_date - interval '18 years'
    and (u.cooldown_until is null or u.cooldown_until <= current_date)
    and not exists (
      select 1
      from public.user_chronic_diseases ucd
      join public.chronic_diseases cd on cd.id = ucd.disease_id
      where ucd.user_id = u.id
        and cd.is_active
        and cd.blocks_donation
    )
    and not exists (
      select 1
      from public.appointments a
      where a.donor_id = u.id
        and a.status in ('pending', 'confirmed')
        and a.deleted_at is null
    )
  order by u.created_at;
end;
$$;

create or replace function public.create_blood_request(
  p_hospital_id uuid,
  p_blood_type public.blood_type_enum,
  p_urgency public.request_urgency_enum,
  p_units_needed integer,
  p_needed_by timestamptz,
  p_notes text
)
returns public.blood_requests
language plpgsql
security definer
set search_path = pg_catalog, public, extensions
as $$
declare
  v_caller uuid := auth.uid();
  v_hospital public.hospitals;
  v_wilaya_name text;
  v_request public.blood_requests;
begin
  if v_caller is null then
    raise exception using errcode = 'P0001', message = 'unauthenticated';
  end if;

  if not exists (
    select 1
    from public.users u
    where u.id = v_caller
      and u.deleted_at is null
      and u.is_active
      and (u.is_recipient or u.active_mode = 'recipient')
  ) then
    raise exception using errcode = 'P0001', message = 'recipient_mode_required';
  end if;

  if p_units_needed is null or p_units_needed <= 0 then
    raise exception using errcode = '22023', message = 'invalid_units_needed';
  end if;

  if p_needed_by is not null and p_needed_by <= now() then
    raise exception using errcode = '22023', message = 'needed_by_must_be_future';
  end if;

  select *
  into v_hospital
  from public.hospitals h
  where h.id = p_hospital_id and h.is_active;

  if not found then
    raise exception using errcode = 'P0001', message = 'hospital_not_found';
  end if;

  select name_ar
  into v_wilaya_name
  from public.wilayas
  where id = v_hospital.wilaya_id;

  insert into public.blood_requests (
    requested_by,
    hospital_name,
    hospital_id,
    city,
    wilaya_id,
    blood_type,
    urgency,
    units_needed,
    needed_by,
    notes,
    expires_at
  )
  values (
    v_caller,
    v_wilaya_name,
    v_hospital.id,
    v_hospital.name_ar,
    v_hospital.wilaya_id,
    p_blood_type,
    p_urgency,
    p_units_needed,
    p_needed_by,
    nullif(btrim(p_notes), ''),
    coalesce(p_needed_by, now() + interval '7 days')
  )
  returning * into v_request;

  return v_request;
end;
$$;

create or replace function public.update_blood_request(
  p_request_id uuid,
  p_hospital_id uuid,
  p_blood_type public.blood_type_enum,
  p_urgency public.request_urgency_enum,
  p_units_needed integer,
  p_needed_by timestamptz,
  p_notes text
)
returns public.blood_requests
language plpgsql
security definer
set search_path = pg_catalog, public, extensions
as $$
declare
  v_caller uuid := auth.uid();
  v_hospital public.hospitals;
  v_wilaya_name text;
  v_request public.blood_requests;
begin
  if v_caller is null then
    raise exception using errcode = 'P0001', message = 'unauthenticated';
  end if;

  if p_units_needed is null or p_units_needed <= 0 then
    raise exception using errcode = '22023', message = 'invalid_units_needed';
  end if;

  if p_needed_by is not null and p_needed_by <= now() then
    raise exception using errcode = '22023', message = 'needed_by_must_be_future';
  end if;

  select *
  into v_hospital
  from public.hospitals h
  where h.id = p_hospital_id and h.is_active;

  if not found then
    raise exception using errcode = 'P0001', message = 'hospital_not_found';
  end if;

  select name_ar
  into v_wilaya_name
  from public.wilayas
  where id = v_hospital.wilaya_id;

  update public.blood_requests r
  set
    hospital_name = v_hospital.name_ar,
    hospital_id = v_hospital.id,
    city = v_wilaya_name,
    wilaya_id = v_hospital.wilaya_id,
    blood_type = p_blood_type,
    urgency = p_urgency,
    units_needed = p_units_needed,
    needed_by = p_needed_by,
    notes = nullif(btrim(p_notes), ''),
    expires_at = coalesce(p_needed_by, r.expires_at)
  where r.id = p_request_id
    and r.requested_by = v_caller
    and r.status = 'open'
    and r.deleted_at is null
    and r.units_fulfilled = 0
  returning * into v_request;

  if not found then
    raise exception using errcode = 'P0001', message = 'request_not_editable';
  end if;

  return v_request;
end;
$$;

create or replace function public.cancel_blood_request(
  p_request_id uuid,
  p_reason text
)
returns public.blood_requests
language plpgsql
security definer
set search_path = pg_catalog, public, extensions
as $$
declare
  v_caller uuid := auth.uid();
  v_request public.blood_requests;
begin
  if v_caller is null then
    raise exception using errcode = 'P0001', message = 'unauthenticated';
  end if;

  if nullif(btrim(p_reason), '') is null then
    raise exception using errcode = '22023', message = 'cancel_reason_required';
  end if;

  update public.blood_requests r
  set
    status = 'cancelled',
    cancelled_at = now(),
    cancel_reason = btrim(p_reason)
  where r.id = p_request_id
    and (r.requested_by = v_caller or public.is_admin())
    and r.status = 'open'
    and r.deleted_at is null
  returning * into v_request;

  if not found then
    raise exception using errcode = 'P0001', message = 'request_not_cancellable';
  end if;

  update public.appointments
  set
    status = 'cancelled',
    cancelled_at = now(),
    cancel_reason = 'request_cancelled'
  where blood_request_id = p_request_id
    and status in ('pending', 'confirmed')
    and deleted_at is null;

  update public.direct_invitations
  set status = 'cancelled'
  where request_id = p_request_id and status = 'sent';

  return v_request;
end;
$$;

create or replace function public.accept_blood_request(
  p_request_id uuid,
  p_scheduled_at timestamptz
)
returns public.appointments
language plpgsql
security definer
set search_path = pg_catalog, public, extensions
as $$
declare
  v_caller uuid := auth.uid();
  v_request public.blood_requests;
  v_appointment public.appointments;
begin
  if v_caller is null then
    raise exception using errcode = 'P0001', message = 'unauthenticated';
  end if;

  if p_scheduled_at is null or p_scheduled_at <= now() then
    raise exception using errcode = '22023', message = 'appointment_must_be_future';
  end if;

  select *
  into v_request
  from public.blood_requests r
  where r.id = p_request_id
    and r.status = 'open'
    and r.deleted_at is null
    and (r.expires_at is null or r.expires_at > now())
  for update;

  if not found then
    raise exception using errcode = 'P0001', message = 'request_not_open';
  end if;

  if p_scheduled_at > coalesce(v_request.needed_by, v_request.expires_at) then
    raise exception using errcode = '22023', message = 'appointment_after_request_deadline';
  end if;

  if not exists (
    select 1
    from public.users u
    join public.blood_type_compatibility c
      on c.donor_type = u.blood_type
     and c.recipient_type = v_request.blood_type
    where u.id = v_caller
      and u.id <> v_request.requested_by
      and u.deleted_at is null
      and u.is_active
      and u.is_donor
      and u.is_available_for_donation
      and u.wilaya_id = v_request.wilaya_id
      and u.date_of_birth <= current_date - interval '18 years'
      and (u.cooldown_until is null or u.cooldown_until <= current_date)
      and not exists (
        select 1
        from public.user_chronic_diseases ucd
        join public.chronic_diseases cd on cd.id = ucd.disease_id
        where ucd.user_id = u.id
          and cd.is_active
          and cd.blocks_donation
      )
  ) then
    raise exception using errcode = 'P0001', message = 'donor_not_eligible';
  end if;

  insert into public.appointments (
    donor_id,
    blood_request_id,
    scheduled_at,
    status
  )
  values (v_caller, p_request_id, p_scheduled_at, 'confirmed')
  returning * into v_appointment;

  insert into public.notifications (
    user_id,
    type,
    title,
    body,
    ref_id,
    ref_type
  )
  values (
    v_request.requested_by,
    'participation_accepted',
    'تم قبول طلب التبرع',
    'وافق متبرع متوافق على طلبك.',
    p_request_id,
    'blood_request'
  );

  return v_appointment;
end;
$$;

create or replace function public.cancel_appointment(
  p_appointment_id uuid,
  p_reason text
)
returns public.appointments
language plpgsql
security definer
set search_path = pg_catalog, public, extensions
as $$
declare
  v_caller uuid := auth.uid();
  v_appointment public.appointments;
begin
  if v_caller is null then
    raise exception using errcode = 'P0001', message = 'unauthenticated';
  end if;

  if nullif(btrim(p_reason), '') is null then
    raise exception using errcode = '22023', message = 'cancel_reason_required';
  end if;

  update public.appointments a
  set
    status = 'cancelled',
    cancelled_at = now(),
    cancel_reason = btrim(p_reason)
  where a.id = p_appointment_id
    and (a.donor_id = v_caller or public.is_admin())
    and a.status in ('pending', 'confirmed')
    and a.deleted_at is null
  returning * into v_appointment;

  if not found then
    raise exception using errcode = 'P0001', message = 'appointment_not_cancellable';
  end if;

  return v_appointment;
end;
$$;

create or replace function public.send_direct_invitation(
  p_request_id uuid,
  p_donor_id uuid
)
returns public.direct_invitations
language plpgsql
security definer
set search_path = pg_catalog, public, extensions
as $$
declare
  v_caller uuid := auth.uid();
  v_request public.blood_requests;
  v_invitation public.direct_invitations;
  v_expires_at timestamptz;
begin
  if v_caller is null then
    raise exception using errcode = 'P0001', message = 'unauthenticated';
  end if;

  select *
  into v_request
  from public.blood_requests r
  where r.id = p_request_id
    and r.requested_by = v_caller
    and r.status = 'open'
    and r.urgency = 'urgent'
    and r.deleted_at is null
  for update;

  if not found then
    raise exception using errcode = 'P0001', message = 'urgent_request_required';
  end if;

  if not exists (
    select 1
    from public.compatible_donors_for_request(p_request_id) d
    where d.donor_id = p_donor_id
  ) then
    raise exception using errcode = 'P0001', message = 'donor_not_compatible';
  end if;

  v_expires_at := least(
    now() + interval '24 hours',
    coalesce(v_request.needed_by, 'infinity'::timestamptz),
    coalesce(v_request.expires_at, 'infinity'::timestamptz)
  );

  if v_expires_at <= now() then
    raise exception using errcode = 'P0001', message = 'request_expired';
  end if;

  insert into public.direct_invitations (
    request_id,
    donor_id,
    expires_at
  )
  values (p_request_id, p_donor_id, v_expires_at)
  returning * into v_invitation;

  insert into public.notifications (
    user_id,
    type,
    title,
    body,
    ref_id,
    ref_type
  )
  values (
    p_donor_id,
    'invitation_received',
    'دعوة عاجلة للتبرع',
    'تلقيت دعوة لطلب دم عاجل متوافق.',
    p_request_id,
    'blood_request'
  );

  return v_invitation;
end;
$$;

create or replace function public.respond_direct_invitation(
  p_invitation_id uuid,
  p_accept boolean,
  p_scheduled_at timestamptz
)
returns public.direct_invitations
language plpgsql
security definer
set search_path = pg_catalog, public, extensions
as $$
declare
  v_caller uuid := auth.uid();
  v_invitation public.direct_invitations;
  v_appointment public.appointments;
  v_requester uuid;
begin
  if v_caller is null then
    raise exception using errcode = 'P0001', message = 'unauthenticated';
  end if;

  select *
  into v_invitation
  from public.direct_invitations i
  where i.id = p_invitation_id
    and i.donor_id = v_caller
    and i.status = 'sent'
  for update;

  if not found then
    raise exception using errcode = 'P0001', message = 'invitation_not_pending';
  end if;

  if v_invitation.expires_at <= now() then
    update public.direct_invitations
    set status = 'expired', responded_at = now()
    where id = p_invitation_id
    returning * into v_invitation;
    return v_invitation;
  end if;

  if p_accept then
    v_appointment := public.accept_blood_request(
      v_invitation.request_id,
      p_scheduled_at
    );

    update public.direct_invitations
    set
      status = 'accepted',
      appointment_id = v_appointment.id,
      responded_at = now()
    where id = p_invitation_id
    returning * into v_invitation;
  else
    update public.direct_invitations
    set status = 'rejected', responded_at = now()
    where id = p_invitation_id
    returning * into v_invitation;
  end if;

  select requested_by
  into v_requester
  from public.blood_requests
  where id = v_invitation.request_id;

  insert into public.notifications (
    user_id,
    type,
    title,
    body,
    ref_id,
    ref_type
  )
  values (
    v_requester,
    'invitation_response',
    'تم الرد على دعوة التبرع',
    case
      when p_accept then 'وافق المتبرع على دعوتك.'
      else 'اعتذر المتبرع عن دعوتك.'
    end,
    v_invitation.request_id,
    'blood_request'
  );

  return v_invitation;
end;
$$;

create or replace function public.issue_request_qr(
  p_request_id uuid
)
returns table (token text, expires_at timestamptz)
language plpgsql
security definer
set search_path = pg_catalog, public, extensions
as $$
declare
  v_caller uuid := auth.uid();
  v_token text;
  v_expires_at timestamptz;
begin
  if v_caller is null then
    raise exception using errcode = 'P0001', message = 'unauthenticated';
  end if;

  select least(
    now() + interval '15 minutes',
    coalesce(r.needed_by, 'infinity'::timestamptz),
    coalesce(r.expires_at, 'infinity'::timestamptz)
  )
  into v_expires_at
  from public.blood_requests r
  where r.id = p_request_id
    and r.requested_by = v_caller
    and r.status = 'open'
    and r.deleted_at is null
  for update;

  if not found or v_expires_at <= now() then
    raise exception using errcode = 'P0001', message = 'request_not_qr_eligible';
  end if;

  delete from public.qr_tokens
  where request_id = p_request_id
    and consumed_at is null
    and expires_at > now();

  v_token := encode(extensions.gen_random_bytes(32), 'hex');

  insert into public.qr_tokens (
    kind,
    token_hash,
    request_id,
    issued_by,
    expires_at
  )
  values (
    'request',
    encode(extensions.digest(v_token, 'sha256'), 'hex'),
    p_request_id,
    v_caller,
    v_expires_at
  );

  return query select v_token, v_expires_at;
end;
$$;

create or replace function public.redeem_request_qr(
  p_token text
)
returns public.donation_records
language plpgsql
security definer
set search_path = pg_catalog, public, extensions
as $$
declare
  v_caller uuid := auth.uid();
  v_qr public.qr_tokens;
  v_appointment public.appointments;
  v_record public.donation_records;
  v_request public.blood_requests;
begin
  if v_caller is null then
    raise exception using errcode = 'P0001', message = 'unauthenticated';
  end if;

  select *
  into v_qr
  from public.qr_tokens q
  where q.kind = 'request'
    and q.token_hash = encode(extensions.digest(p_token, 'sha256'), 'hex')
  for update;

  if not found then
    raise exception using errcode = 'P0001', message = 'qr_invalid';
  end if;

  if v_qr.consumed_at is not null then
    raise exception using errcode = 'P0001', message = 'qr_already_used';
  end if;

  if v_qr.expires_at <= now() then
    raise exception using errcode = 'P0001', message = 'qr_expired';
  end if;

  select a.*
  into v_appointment
  from public.appointments a
  where a.blood_request_id = v_qr.request_id
    and a.donor_id = v_caller
    and a.status in ('pending', 'confirmed')
    and a.deleted_at is null
  for update;

  if not found then
    raise exception using errcode = 'P0001', message = 'appointment_required';
  end if;

  select *
  into v_request
  from public.blood_requests
  where id = v_qr.request_id and status = 'open'
  for update;

  if not found then
    raise exception using errcode = 'P0001', message = 'request_not_open';
  end if;

  update public.qr_tokens
  set consumed_at = now(), consumed_by = v_caller
  where id = v_qr.id;

  update public.appointments
  set status = 'completed', completed_at = now()
  where id = v_appointment.id;

  insert into public.donation_records (
    donor_id,
    source,
    request_id,
    appointment_id,
    hospital_id
  )
  values (
    v_caller,
    'request',
    v_request.id,
    v_appointment.id,
    v_request.hospital_id
  )
  returning * into v_record;

  insert into public.point_transactions (
    donor_id,
    amount,
    reason,
    ref_id,
    ref_type
  )
  values (v_caller, 10, 'donation', v_appointment.id, 'appointment');

  update public.users
  set cooldown_until = current_date + 90
  where id = v_caller;

  if exists (
    select 1
    from public.blood_requests
    where id = v_request.id and status = 'fulfilled'
  ) then
    update public.appointments
    set
      status = 'cancelled',
      cancelled_at = now(),
      cancel_reason = 'request_fulfilled'
    where blood_request_id = v_request.id
      and id <> v_appointment.id
      and status in ('pending', 'confirmed')
      and deleted_at is null;

    update public.direct_invitations
    set status = 'cancelled'
    where request_id = v_request.id and status = 'sent';
  end if;

  insert into public.notifications (
    user_id,
    type,
    title,
    body,
    ref_id,
    ref_type
  )
  values
    (
      v_caller,
      'donation_confirmed',
      'تم تأكيد التبرع',
      'شكرا لك، تم تسجيل تبرعك وإضافة النقاط.',
      v_appointment.id,
      'appointment'
    ),
    (
      v_request.requested_by,
      'request_update',
      'تم تسجيل تبرع جديد',
      'تم تأكيد وحدة دم جديدة لطلبك.',
      v_request.id,
      'blood_request'
    );

  return v_record;
end;
$$;

create or replace function public.issue_campaign_qr(
  p_campaign_id uuid
)
returns table (token text, expires_at timestamptz)
language plpgsql
security definer
set search_path = pg_catalog, public, extensions
as $$
declare
  v_caller uuid := auth.uid();
  v_token text;
  v_expires_at timestamptz;
begin
  if v_caller is null or not public.is_admin() then
    raise exception using errcode = 'P0001', message = 'admin_required';
  end if;

  select c.ends_at
  into v_expires_at
  from public.campaigns c
  where c.id = p_campaign_id
    and c.published_at is not null
    and c.status in ('upcoming', 'active')
    and c.deleted_at is null
    and c.ends_at > now()
  for update;

  if not found then
    raise exception using errcode = 'P0001', message = 'campaign_not_qr_eligible';
  end if;

  delete from public.qr_tokens
  where campaign_id = p_campaign_id and expires_at > now();

  v_token := encode(extensions.gen_random_bytes(32), 'hex');

  insert into public.qr_tokens (
    kind,
    token_hash,
    campaign_id,
    issued_by,
    expires_at
  )
  values (
    'campaign',
    encode(extensions.digest(v_token, 'sha256'), 'hex'),
    p_campaign_id,
    v_caller,
    v_expires_at
  );

  return query select v_token, v_expires_at;
end;
$$;

create or replace function public.redeem_campaign_qr(
  p_token text
)
returns public.donation_records
language plpgsql
security definer
set search_path = pg_catalog, public, extensions
as $$
declare
  v_caller uuid := auth.uid();
  v_qr public.qr_tokens;
  v_campaign public.campaigns;
  v_user public.users;
  v_record public.donation_records;
begin
  if v_caller is null then
    raise exception using errcode = 'P0001', message = 'unauthenticated';
  end if;

  select *
  into v_qr
  from public.qr_tokens q
  where q.kind = 'campaign'
    and q.token_hash = encode(extensions.digest(p_token, 'sha256'), 'hex')
  for share;

  if not found then
    raise exception using errcode = 'P0001', message = 'qr_invalid';
  end if;

  if v_qr.expires_at <= now() then
    raise exception using errcode = 'P0001', message = 'qr_expired';
  end if;

  select *
  into v_campaign
  from public.campaigns c
  where c.id = v_qr.campaign_id
    and c.published_at is not null
    and c.status in ('upcoming', 'active')
    and c.deleted_at is null
    and now() between c.starts_at and c.ends_at;

  if not found then
    raise exception using errcode = 'P0001', message = 'campaign_not_active';
  end if;

  select *
  into v_user
  from public.users u
  where u.id = v_caller
    and u.deleted_at is null
    and u.is_active
    and u.is_donor
    and u.is_available_for_donation
    and u.wilaya_id = v_campaign.wilaya_id
    and u.date_of_birth <= current_date - interval '18 years'
    and (u.cooldown_until is null or u.cooldown_until <= current_date)
    and (
      v_campaign.blood_types_needed is null
      or u.blood_type = any(v_campaign.blood_types_needed)
    )
    and not exists (
      select 1
      from public.user_chronic_diseases ucd
      join public.chronic_diseases cd on cd.id = ucd.disease_id
      where ucd.user_id = u.id
        and cd.is_active
        and cd.blocks_donation
    )
  for update;

  if not found then
    raise exception using errcode = 'P0001', message = 'donor_not_eligible';
  end if;

  insert into public.donation_records (
    donor_id,
    source,
    campaign_id,
    hospital_id
  )
  values (
    v_caller,
    'campaign',
    v_campaign.id,
    v_campaign.hospital_id
  )
  returning * into v_record;

  insert into public.point_transactions (
    donor_id,
    amount,
    reason,
    ref_id,
    ref_type
  )
  values (v_caller, 10, 'donation', v_campaign.id, null);

  update public.users
  set
    last_donation_date = current_date,
    total_donations_count = total_donations_count + 1,
    cooldown_until = current_date + 90
  where id = v_caller;

  insert into public.notifications (
    user_id,
    type,
    title,
    body,
    ref_id,
    ref_type
  )
  values (
    v_caller,
    'donation_confirmed',
    'تم تأكيد التبرع',
    'شكرا لك، تم تسجيل تبرعك في الحملة وإضافة النقاط.',
    v_campaign.id,
    'campaign'
  );

  return v_record;
end;
$$;

revoke all on function public.compatible_donors_for_request(uuid) from public;
revoke all on function public.create_blood_request(
  uuid,
  public.blood_type_enum,
  public.request_urgency_enum,
  integer,
  timestamptz,
  text
) from public;
revoke all on function public.update_blood_request(
  uuid,
  uuid,
  public.blood_type_enum,
  public.request_urgency_enum,
  integer,
  timestamptz,
  text
) from public;
revoke all on function public.cancel_blood_request(uuid, text) from public;
revoke all on function public.accept_blood_request(uuid, timestamptz) from public;
revoke all on function public.cancel_appointment(uuid, text) from public;
revoke all on function public.send_direct_invitation(uuid, uuid) from public;
revoke all on function public.respond_direct_invitation(
  uuid,
  boolean,
  timestamptz
) from public;
revoke all on function public.issue_request_qr(uuid) from public;
revoke all on function public.redeem_request_qr(text) from public;
revoke all on function public.issue_campaign_qr(uuid) from public;
revoke all on function public.redeem_campaign_qr(text) from public;

grant execute on function public.compatible_donors_for_request(uuid)
  to authenticated;
grant execute on function public.create_blood_request(
  uuid,
  public.blood_type_enum,
  public.request_urgency_enum,
  integer,
  timestamptz,
  text
) to authenticated;
grant execute on function public.update_blood_request(
  uuid,
  uuid,
  public.blood_type_enum,
  public.request_urgency_enum,
  integer,
  timestamptz,
  text
) to authenticated;
grant execute on function public.cancel_blood_request(uuid, text)
  to authenticated;
grant execute on function public.accept_blood_request(uuid, timestamptz)
  to authenticated;
grant execute on function public.cancel_appointment(uuid, text)
  to authenticated;
grant execute on function public.send_direct_invitation(uuid, uuid)
  to authenticated;
grant execute on function public.respond_direct_invitation(
  uuid,
  boolean,
  timestamptz
) to authenticated;
grant execute on function public.issue_request_qr(uuid)
  to authenticated;
grant execute on function public.redeem_request_qr(text)
  to authenticated;
grant execute on function public.issue_campaign_qr(uuid)
  to authenticated;
grant execute on function public.redeem_campaign_qr(text)
  to authenticated;
