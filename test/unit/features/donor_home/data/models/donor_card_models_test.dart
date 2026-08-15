import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tabare3/core/usecases/usecase.dart';
import 'package:tabare3/features/donor_home/data/datasources/donor_card_remote_data_source.dart';
import 'package:tabare3/features/donor_home/data/models/donor_card_models.dart';
import 'package:tabare3/features/donor_home/data/repositories/donor_card_repository_impl.dart';
import 'package:tabare3/features/donor_home/domain/repositories/donor_card_repository.dart';
import 'package:tabare3/features/donor_home/domain/usecases/get_donor_card.dart';

class MockDonorCardRemoteDataSource extends Mock
    implements DonorCardRemoteDataSource {}

class MockDonorCardRepository extends Mock implements DonorCardRepository {}

void main() {
  final model = DonorCardModel(
    summary: const DonorCardSummaryModel(totalPoints: 18, totalDonations: 2),
    levels: const [
      DonorLevelModel(levelNumber: 1, minPoints: 0, nameAr: 'قطرة أمل'),
      DonorLevelModel(levelNumber: 2, minPoints: 10, nameAr: 'متبرع نشط'),
      DonorLevelModel(levelNumber: 3, minPoints: 50, nameAr: 'متبرع ملتزم'),
    ],
    badges: [
      EarnedDonorBadgeModel(
        earnedAt: DateTime.utc(2026, 7, 30),
        badge: const DonorBadgeModel(id: 'badge-1', nameAr: 'شارة'),
      ),
    ],
  );
  final entity = model.toEntity();

  test('maps donor card backend models and computes level progress', () {
    expect(entity.totalPoints, 18);
    expect(entity.currentLevel?.nameAr, 'متبرع نشط');
    expect(entity.nextLevel?.minPoints, 50);
    expect(entity.levelProgress, closeTo(0.2, 0.001));
    expect(entity.badges.single.nameAr, 'شارة');
  });

  test('parses nested earned badge payloads', () {
    final badge = EarnedDonorBadgeModel.fromJson({
      'earned_at': '2026-07-30T10:00:00.000Z',
      'badge': {'id': 'badge-1', 'name_ar': 'شارة'},
    });

    expect(badge.toEntity().id, 'badge-1');
  });

  test('repository maps the RLS-scoped model', () async {
    final source = MockDonorCardRemoteDataSource();
    when(() => source.getDonorCard()).thenAnswer((_) async => model);
    final repository = DonorCardRepositoryImpl(remoteDataSource: source);

    expect(await repository.getDonorCard(), Right(entity));
  });

  test('use case forwards the donor card repository result', () async {
    final repository = MockDonorCardRepository();
    when(
      () => repository.getDonorCard(),
    ).thenAnswer((_) async => Right(entity));

    expect(await GetDonorCard(repository)(NoParams()), Right(entity));
  });
}
