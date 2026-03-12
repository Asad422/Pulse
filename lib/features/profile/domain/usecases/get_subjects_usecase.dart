import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:pulse/core/failure/failure.dart';
import '../entities/subject.dart';
import '../repositories/user_repository.dart';

@lazySingleton
class GetSubjectsUseCase {
  final UserRepository _repository;
  GetSubjectsUseCase(this._repository);

  Future<Either<Failure, List<Subject>>> call() {
    return _repository.getSubjects();
  }
}
