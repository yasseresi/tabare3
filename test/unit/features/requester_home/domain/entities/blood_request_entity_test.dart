import 'package:flutter_test/flutter_test.dart';
import 'package:tabare3/features/requester_home/domain/entities/blood_request_entity.dart';

void main() {
  test('database priority values map to the agreed three UI priorities', () {
    expect(RequestPriority.fromDatabase('normal'), RequestPriority.normal);
    expect(
      RequestPriority.fromDatabase('semi_urgent'),
      RequestPriority.semiUrgent,
    );
    expect(RequestPriority.fromDatabase('urgent'), RequestPriority.urgent);
    expect(RequestPriority.semiUrgent.databaseValue, 'semi_urgent');
  });

  test('request exposes governed hospital and fulfilment progress', () {
    final request = BloodRequestEntity(
      id: 'request-id',
      requestedBy: 'recipient-id',
      hospital: const HospitalEntity(
        id: 'hospital-id',
        wilayaId: 16,
        nameAr: 'مستشفى مصطفى باشا',
        nameFr: 'Mustapha Pacha',
        isActive: true,
      ),
      bloodType: 'A+',
      priority: RequestPriority.urgent,
      unitsNeeded: 3,
      unitsFulfilled: 1,
      status: BloodRequestStatus.open,
      neededBy: DateTime.utc(2030, 1, 2),
      createdAt: DateTime.utc(2030),
    );

    expect(request.remainingUnits, 2);
    expect(request.isActive, true);
    expect(request.hospital.wilayaId, 16);
  });

  test('recipient donor summary exposes only privacy-safe identity fields', () {
    final donor = RequestDonorEntity(
      donorId: 'donor-id',
      fullName: 'متبرع مختبر',
      bloodType: 'O-',
      appointmentId: 'appointment-id',
      status: DonationAppointmentStatus.completed,
      scheduledAt: DateTime.utc(2030, 1, 2),
      completedAt: DateTime.utc(2030, 1, 2, 12),
    );

    expect(donor.fullName, 'متبرع مختبر');
    expect(donor.status, DonationAppointmentStatus.completed);
  });

  test('compatible donor and issued QR preserve server eligibility data', () {
    const donor = CompatibleDonorEntity(
      donorId: 'donor-id',
      fullName: 'متبرع متاح',
      bloodType: 'A+',
      wilayaId: 16,
    );
    final qr = IssuedRequestQrEntity(
      token: 'opaque-token',
      expiresAt: DateTime.utc(2030, 1, 2),
    );

    expect(donor.wilayaId, 16);
    expect(qr.isExpiredAt(DateTime.utc(2030, 1, 1)), false);
    expect(qr.isExpiredAt(DateTime.utc(2030, 1, 3)), true);
  });

  test('direct invitation exposes its server lifecycle', () {
    final invitation = DirectInvitationEntity(
      invitationId: 'invitation-id',
      donorId: 'donor-id',
      fullName: 'متبرع مدعو',
      bloodType: 'O-',
      status: DirectInvitationStatus.expired,
      expiresAt: DateTime.utc(2030),
      createdAt: DateTime.utc(2029),
    );

    expect(invitation.status, DirectInvitationStatus.expired);
    expect(invitation.fullName, 'متبرع مدعو');
  });
}
