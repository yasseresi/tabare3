import 'package:flutter_test/flutter_test.dart';
import 'package:tabare3/features/requester_home/data/models/request_models.dart';
import 'package:tabare3/features/requester_home/domain/entities/blood_request_entity.dart';

void main() {
  const hospitalJson = {
    'id': 'hospital-id',
    'wilaya_id': 16,
    'name_ar': 'مستشفى مصطفى باشا',
    'name_fr': 'Mustapha Pacha',
    'address': 'الجزائر',
    'is_active': true,
  };

  test('HospitalModel maps governed reference data', () {
    final model = HospitalModel.fromJson(hospitalJson);

    expect(model.toEntity().wilayaId, 16);
    expect(model.toEntity().nameAr, 'مستشفى مصطفى باشا');
  });

  test('BloodRequestModel maps nested hospital and canonical priority', () {
    final model = BloodRequestModel.fromJson({
      'id': 'request-id',
      'requested_by': 'recipient-id',
      'hospital': hospitalJson,
      'beneficiary_type': 'self',
      'patient': {
        'full_name': 'صاحب الحساب',
        'national_id': '123456789012345678',
        'blood_type': 'A+',
        'weight': 70,
        'chronic_diseases': null,
        'gender': 'male',
        'date_of_birth': '2000-01-01',
      },
      'blood_type': 'A+',
      'urgency': 'semi_urgent',
      'units_needed': 3,
      'units_fulfilled': 1,
      'status': 'open',
      'needed_by': '2030-01-02T00:00:00.000Z',
      'expires_at': '2030-01-03T00:00:00.000Z',
      'notes': 'ملاحظة',
      'created_at': '2030-01-01T00:00:00.000Z',
    });

    final entity = model.toEntity();

    expect(entity.priority, RequestPriority.semiUrgent);
    expect(entity.remainingUnits, 2);
    expect(entity.hospital.id, 'hospital-id');
    expect(entity.beneficiaryType, BeneficiaryType.self);
    expect(entity.patient?.fullName, 'صاحب الحساب');
  });

  test('request RPC payload uses backend enum and ISO timestamps', () {
    final payload = buildRequestRpcPayload(
      RequestDraft(
        hospitalId: 'hospital-id',
        beneficiaryType: BeneficiaryType.other,
        patient: const PatientDraft(
          fullName: 'مريض مختبر',
          nationalId: '123456789012345678',
          bloodType: 'O-',
          weight: 65,
          chronicDiseases: 'لا يوجد',
          gender: 'male',
          dateOfBirth: '2000-01-01',
        ),
        bloodType: 'O-',
        priority: RequestPriority.urgent,
        unitsNeeded: 2,
        neededBy: DateTime.utc(2030, 1, 2),
        notes: 'note',
      ),
    );

    expect(payload, {
      'p_hospital_id': 'hospital-id',
      'p_beneficiary_type': 'other',
      'p_patient_full_name': 'مريض مختبر',
      'p_patient_national_id': '123456789012345678',
      'p_patient_blood_type': 'O-',
      'p_patient_weight': 65,
      'p_patient_chronic_diseases': 'لا يوجد',
      'p_patient_gender': 'male',
      'p_patient_date_of_birth': '2000-01-01',
      'p_blood_type': 'O-',
      'p_urgency': 'urgent',
      'p_units_needed': 2,
      'p_needed_by': '2030-01-02T00:00:00.000Z',
      'p_notes': 'note',
    });
  });

  test('privacy-safe donor row maps appointment status and dates', () {
    final model = RequestDonorModel.fromJson({
      'donor_id': 'donor-id',
      'full_name': 'متبرع مختبر',
      'blood_type': 'O-',
      'appointment_id': 'appointment-id',
      'status': 'completed',
      'scheduled_at': '2030-01-02T00:00:00.000Z',
      'completed_at': '2030-01-02T12:00:00.000Z',
    });

    expect(model.toEntity().status, DonationAppointmentStatus.completed);
    expect(model.toEntity().fullName, 'متبرع مختبر');
  });

  test('compatible donor and request QR rows map RPC results', () {
    final donor = CompatibleDonorModel.fromJson({
      'donor_id': 'donor-id',
      'full_name': 'متبرع متاح',
      'blood_type': 'A+',
      'wilaya_id': 16,
      'cooldown_until': null,
    });
    final qr = IssuedRequestQrModel.fromJson({
      'token': 'opaque-token',
      'expires_at': '2030-01-02T00:00:00.000Z',
    });

    expect(donor.toEntity().wilayaId, 16);
    expect(qr.toEntity().token, 'opaque-token');
  });

  test('direct invitation model maps every server status', () {
    final model = DirectInvitationModel.fromJson({
      'invitation_id': 'invitation-id',
      'donor_id': 'donor-id',
      'full_name': 'متبرع مدعو',
      'blood_type': 'O-',
      'status': 'accepted',
      'appointment_id': 'appointment-id',
      'expires_at': '2030-01-02T00:00:00.000Z',
      'responded_at': '2030-01-01T12:00:00.000Z',
      'created_at': '2030-01-01T00:00:00.000Z',
    });

    expect(model.toEntity().status, DirectInvitationStatus.accepted);
    expect(model.toEntity().appointmentId, 'appointment-id');
  });
}
