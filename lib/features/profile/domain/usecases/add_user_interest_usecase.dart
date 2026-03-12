import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:pulse/core/failure/failure.dart';
import '../repositories/user_repository.dart';

@lazySingleton
class AddUserInterestUseCase {
  final UserRepository _repository;
  AddUserInterestUseCase(this._repository);

  Future<Either<Failure, void>> call({required int subjectId}) {
    return _repository.addUserInterest(subjectId);
  }
}
