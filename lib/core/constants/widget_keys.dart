import 'package:flutter/widgets.dart';

/// Stable widget keys for testing. No raw key strings inside views.
class WidgetKeys {
  static const Key splashProgressBar = Key('splash_progress_bar');
  static const Key logoutDialogConfirmButton = Key('logout_dialog_confirm');
  static const Key logoutDialogCancelButton = Key('logout_dialog_cancel');
  static const Key requestHospitalField = Key('request_hospital_field');
  static const Key requestBloodTypeField = Key('request_blood_type_field');
  static const Key requestUnitsField = Key('request_units_field');
  static const Key requestNotesField = Key('request_notes_field');
  static const Key requestSubmitButton = Key('request_submit_button');
  static const Key requestEditButton = Key('request_edit_button');
  static const Key requestEditSaveButton = Key('request_edit_save_button');
  static const Key requestCancelButton = Key('request_cancel_button');
  static const Key requestCancelReasonField = Key(
    'request_cancel_reason_field',
  );
  static const Key requestCancelConfirmButton = Key(
    'request_cancel_confirm_button',
  );
  static const Key requestsRetryButton = Key('requests_retry_button');
  static const Key requestDetailsButton = Key('request_details_button');
  static const Key requestQrIssueButton = Key('request_qr_issue_button');
  static const Key requestQrView = Key('request_qr_view');
  static const Key compatibleDonorInviteButton = Key(
    'compatible_donor_invite_button',
  );
}
