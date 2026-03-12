import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:pulse/core/failure/failure.dart';
import '../entities/law.dart';
import '../repositories/laws_repository.dart';

@lazySingleton
class GetLawByIdentityUseCase {
  final LawsRepository _repo;
  GetLawByIdentityUseCase(this._repo);

  Future<Either<Failure, Law>> call({required int congress, required String lawType, required String lawNumber}) {
    return _repo.getLawByIdentity(congress: congress, lawType: lawType, lawNumber: lawNumber);
  }
}
