import 'package:flutter_test/flutter_test.dart';
import 'package:tabare3/features/donor_home/domain/entities/donor_feed_entity.dart';

void main() {
  final now = DateTime.utc(2030, 1, 10, 12);

  test('availability stays in cooldown until the server date passes', () {
    final availability = DonorAvailabilityEntity(
      userId: 'donor-1',
      isAccountActive: true,
      isAvailableForDonation: true,
      isDonor: true,
      bloodType: 'O+',
      wilayaId: 16,
      cooldownUntil: DateTime.utc(2030, 1, 11),
      lastDonationDate: DateTime.utc(2030, 1, 1),
      totalDonationsCount: 3,
    );

    expect(availability.isEligibleAt(now), false);
    expect(availability.nextEligibilityAt(), DateTime.utc(2030, 1, 12));
  });

  test('request and campaign helpers preserve server-driven state', () {
    final request = DonorBloodRequestEntity(
      id: 'request-1',
      requestedBy: 'recipient-1',
      hospital: const DonorHospitalEntity(
        id: 'hospital-1',
        wilayaId: 16,
        nameAr: 'مستشفى مصطفى باشا',
        isActive: true,
      ),
      bloodType: 'A+',
      priority: DonorRequestPriority.urgent,
      unitsNeeded: 3,
      unitsFulfilled: 1,
      status: DonorBloodRequestStatus.open,
      createdAt: now,
    );
    final campaign = DonorCampaignEntity(
      id: 'campaign-1',
      organizerName: 'جمعية تبرع',
      title: 'حملة شتوية',
      venueName: 'قاعة المؤتمرات',
      city: 'الجزائر',
      wilayaId: 16,
      hospitalId: 'hospital-1',
      bloodTypesNeeded: const ['O+', 'A+'],
      status: DonorCampaignStatus.active,
      startsAt: now.subtract(const Duration(hours: 1)),
      endsAt: now.add(const Duration(hours: 4)),
      publishedAt: now.subtract(const Duration(days: 1)),
      createdAt: now.subtract(const Duration(days: 2)),
    );

    expect(request.remainingUnits, 2);
    expect(request.isAcceptingDonors, true);
    expect(campaign.acceptsBloodType('A+'), true);
    expect(campaign.acceptsBloodType('B-'), false);
    expect(campaign.isVisibleAt(now), true);
  });

  test('feed reports whether donor already has an active appointment', () {
    final appointment = DonorAppointmentEntity(
      id: 'appointment-1',
      donorId: 'donor-1',
      scheduledAt: now.add(const Duration(days: 1)),
      status: DonationAppointmentStatus.confirmed,
      createdAt: now,
      bloodRequest: DonorAppointmentRequestRef(
        id: 'request-1',
        hospital: const DonorHospitalEntity(
          id: 'hospital-1',
          wilayaId: 16,
          nameAr: 'مستشفى',
          isActive: true,
        ),
        bloodType: 'O+',
        priority: DonorRequestPriority.normal,
        neededBy: now.add(const Duration(days: 2)),
      ),
    );

    final feed = DonorFeedEntity(
      availability: DonorAvailabilityEntity(
        userId: 'donor-1',
        isAccountActive: true,
        isAvailableForDonation: true,
        isDonor: true,
        bloodType: 'O+',
        wilayaId: 16,
        totalDonationsCount: 0,
      ),
      compatibleRequests: const [],
      availableCampaigns: const [],
      appointments: [appointment],
    );

    expect(feed.hasBlockingAppointment, true);
    expect(feed.activeAppointment?.id, 'appointment-1');
  });
}
