import 'package:flutter_test/flutter_test.dart';
import 'package:tabare3/features/donor_home/data/datasources/donor_feed_remote_data_source.dart';
import 'package:tabare3/features/donor_home/data/datasources/donor_card_remote_data_source.dart';
import 'package:tabare3/features/donor_home/domain/repositories/donor_card_repository.dart';
import 'package:tabare3/features/donor_home/domain/repositories/donor_feed_repository.dart';
import 'package:tabare3/features/donor_home/domain/usecases/donor_feed_usecases.dart';
import 'package:tabare3/features/donor_home/domain/usecases/get_donor_card.dart';
import 'package:tabare3/features/donor_home/presentation/bloc/donor_card_bloc.dart';
import 'package:tabare3/features/donor_home/presentation/bloc/donor_feed_bloc.dart';
import 'package:tabare3/injection_container.dart';

import '../support/fake_backend.dart';

void main() {
  tearDown(() async {
    await sl.reset();
  });

  test('registers the complete donor home dependency graph', () async {
    await initCore(const FakeBackend());
    await initDonorHome();

    expect(sl.isRegistered<DonorFeedRemoteDataSource>(), isTrue);
    expect(sl.isRegistered<DonorFeedRepository>(), isTrue);
    expect(sl.isRegistered<GetDonorFeed>(), isTrue);
    expect(sl.isRegistered<GetDonationRecords>(), isTrue);
    expect(sl.isRegistered<AcceptBloodRequest>(), isTrue);
    expect(sl.isRegistered<CancelDonationAppointment>(), isTrue);
    expect(sl.isRegistered<RedeemRequestDonation>(), isTrue);
    expect(sl.isRegistered<RedeemCampaignDonation>(), isTrue);
    expect(sl.isRegistered<DonorFeedBloc>(), isTrue);
    expect(sl.isRegistered<DonorCardRemoteDataSource>(), isTrue);
    expect(sl.isRegistered<DonorCardRepository>(), isTrue);
    expect(sl.isRegistered<GetDonorCard>(), isTrue);
    expect(sl.isRegistered<DonorCardBloc>(), isTrue);
  });
}
