import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/donor_card_entity.dart';

abstract class DonorCardRepository {
  Future<Either<Failure, DonorCardEntity>> getDonorCard();
}
