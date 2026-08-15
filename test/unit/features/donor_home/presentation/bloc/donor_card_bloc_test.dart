import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tabare3/core/usecases/usecase.dart';
import 'package:tabare3/features/donor_home/domain/entities/donor_card_entity.dart';
import 'package:tabare3/features/donor_home/domain/usecases/get_donor_card.dart';
import 'package:tabare3/features/donor_home/presentation/bloc/donor_card_bloc.dart';

class MockGetDonorCard extends Mock implements GetDonorCard {}

void main() {
  late MockGetDonorCard getDonorCard;

  const card = DonorCardEntity(
    totalPoints: 18,
    totalDonations: 2,
    levels: [
      DonorLevelEntity(levelNumber: 1, minPoints: 0, nameAr: 'قطرة أمل'),
      DonorLevelEntity(levelNumber: 2, minPoints: 10, nameAr: 'متبرع نشط'),
      DonorLevelEntity(levelNumber: 3, minPoints: 50, nameAr: 'متبرع ملتزم'),
    ],
    badges: [],
  );

  setUpAll(() {
    registerFallbackValue(NoParams());
  });

  setUp(() {
    getDonorCard = MockGetDonorCard();
  });

  blocTest<DonorCardBloc, DonorCardState>(
    'loads the RLS-scoped donor card',
    build: () {
      when(
        () => getDonorCard(any()),
      ).thenAnswer((_) async => const Right(card));
      return DonorCardBloc(getDonorCard: getDonorCard);
    },
    act: (bloc) => bloc.add(const DonorCardRequested()),
    expect: () => [const DonorCardLoading(), const DonorCardLoaded(card)],
  );
}
