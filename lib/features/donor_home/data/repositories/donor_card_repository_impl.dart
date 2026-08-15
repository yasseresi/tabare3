import 'package:dartz/dartz.dart';

import '../../../../core/error/error_handler.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/donor_card_entity.dart';
import '../../domain/repositories/donor_card_repository.dart';
import '../datasources/donor_card_remote_data_source.dart';

class DonorCardRepositoryImpl implements DonorCardRepository {
  final DonorCardRemoteDataSource remoteDataSource;

  DonorCardRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, DonorCardEntity>> getDonorCard() async {
    try {
      final model = await remoteDataSource.getDonorCard();
      return Right(model.toEntity());
    } catch (error) {
      return Left(ErrorHandler.handle(error));
    }
  }
}
