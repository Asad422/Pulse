import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:pulse/core/failure/failure.dart';
import '../entities/law.dart';
import '../repositories/laws_repository.dart';

@lazySingleton
class GetLawUseCase {
  final LawsRepository _repo;
  GetLawUseCase(this._repo);

  Future<Either<Failure, Law>> call(int lawId) {
    return _repo.getLaw(lawId);
  }
}
