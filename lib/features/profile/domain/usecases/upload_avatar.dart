import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/profile_repository.dart';

class UploadAvatar implements BaseUseCase<String, String> {
  final ProfileRepository repository;

  UploadAvatar(this.repository);

  @override
  Future<Either<Failure, String>> call(String filePath) {
    return repository.uploadAvatar(filePath);
  }
}
