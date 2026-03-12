import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:pulse/core/failure/failure.dart';
import '../entities/profile_enums.dart';
import '../repositories/user_repository.dart';

@lazySingleton
class GetProfileEnumsUseCase {
  final UserRepository _repository;
  GetProfileEnumsUseCase(this._repository);

  Future<Either<Failure, ProfileEnums>> call() {
    return _repository.getProfileEnums();
  }
}
