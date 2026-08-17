/// Endpoint paths for the custom Django REST backend, relative to the
/// `API_BASE_URL` (which already ends in `/api/v1`).
///
/// Every REST data source references these constants — no inline path literals.
/// Source of truth: `docs/blood_api_schema.yaml` (live OpenAPI schema).
class RestPaths {
  RestPaths._();

  // --- Auth (accounts) ---
  static const String register = '/auth/register/';
  static const String login = '/auth/login/';
  static const String refresh = '/auth/refresh/';
  static const String emailAvailable = '/auth/email-available/';
  static const String passwordReset = '/auth/password-reset/';
  static const String passwordResetConfirm = '/auth/password-reset/confirm/';

  // --- Profile ---
  static const String profile = '/profile/';
  static const String switchMode = '/profile/switch-mode/';
  static const String toggleStatus = '/profile/toggle-status/';
  static const String eligibility = '/profile/eligibility/';

  // --- Blood requests + feed ---
  static const String requests = '/requests/';
  static const String feedRequests = '/feed/requests/';
  static String request(Object id) => '/requests/$id/';
  static String requestCancel(Object id) => '/requests/$id/cancel/';
  static String requestAccept(Object id) => '/requests/$id/accept/';
  static String requestReactivate(Object id) => '/requests/$id/reactivate/';
  static String requestInvite(Object id) => '/requests/$id/invite/';
  static String requestMatchingDonors(Object id) => '/requests/$id/matching-donors/';

  // --- Appointments ---
  static const String appointments = '/appointments/';
  static const String myAppointment = '/appointments/mine/';
  static String appointmentCancel(Object id) => '/appointments/$id/cancel/';

  // --- Invitations ---
  static const String invitations = '/invitations/';
  static String invitationRespond(Object id) => '/invitations/$id/respond/';

  // --- Campaigns ---
  static const String campaigns = '/campaigns/';
  static const String feedCampaigns = '/feed/campaigns/';
  static String campaignScan(Object token) => '/campaigns/scan/$token/';

  // --- Donations (QR redeem lives here) ---
  static const String donations = '/donations/';
  static const String donationScan = '/donations/scan/';
  static String donationScanToken(Object token) => '/donations/scan/$token/';

  // --- Donor card / gamification ---
  static const String donorCard = '/donor-card/';
  static const String donorCardLedger = '/donor-card/ledger/';
  static const String levels = '/levels/';
  static const String badges = '/badges/';

  // --- Notifications ---
  static const String notifications = '/notifications/';
  static const String notificationsUnreadCount = '/notifications/unread-count/';
  static const String notificationsMarkAllRead = '/notifications/mark-all-read/';
  static const String notificationsBroadcast = '/notifications/broadcast/';
  static String notificationMarkRead(Object id) => '/notifications/$id/mark-read/';

  // --- Reference / master data ---
  static const String refWilayas = '/references/wilayas/';
  static const String refBloodTypes = '/references/blood-types/';
  static const String refChronicDiseases = '/references/chronic-diseases/';
  static const String refHospitals = '/references/hospitals/';
  static const String refAssociations = '/references/associations/';
}
