revoke execute on function public.compatible_donors_for_request(uuid)
  from anon;
revoke execute on function public.create_blood_request(
  uuid,
  public.blood_type_enum,
  public.request_urgency_enum,
  integer,
  timestamptz,
  text
) from anon;
revoke execute on function public.update_blood_request(
  uuid,
  uuid,
  public.blood_type_enum,
  public.request_urgency_enum,
  integer,
  timestamptz,
  text
) from anon;
revoke execute on function public.cancel_blood_request(uuid, text)
  from anon;
revoke execute on function public.accept_blood_request(uuid, timestamptz)
  from anon;
revoke execute on function public.cancel_appointment(uuid, text)
  from anon;
revoke execute on function public.send_direct_invitation(uuid, uuid)
  from anon;
revoke execute on function public.respond_direct_invitation(
  uuid,
  boolean,
  timestamptz
) from anon;
revoke execute on function public.issue_request_qr(uuid)
  from anon;
revoke execute on function public.redeem_request_qr(text)
  from anon;
revoke execute on function public.issue_campaign_qr(uuid)
  from anon;
revoke execute on function public.redeem_campaign_qr(text)
  from anon;
revoke execute on function public.admin_correct_identity(
  uuid,
  text,
  text,
  text
) from anon;
revoke execute on function public.is_admin() from anon;
revoke execute on function public.handle_new_user() from anon;

create policy qr_tokens_deny_client_access
  on public.qr_tokens
  for all
  to anon, authenticated
  using (false)
  with check (false);
