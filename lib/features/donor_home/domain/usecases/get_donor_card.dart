import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/donor_card_entity.dart';
import '../repositories/donor_card_repository.dart';

class GetDonorCard implements BaseUseCase<DonorCardEntity, NoParams> {
  final DonorCardRepository repository;

  GetDonorCard(this.repository);

  @override
  Future<Either<Failure, DonorCardEntity>> call(NoParams params) {
    return repository.getDonorCard();
  }
}
