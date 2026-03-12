import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:pulse/core/failure/failure.dart';
import '../entities/law.dart';
import '../entities/laws_query.dart';
import '../repositories/laws_repository.dart';

@lazySingleton
class GetLawsUseCase {
  final LawsRepository _repo;
  GetLawsUseCase(this._repo);

  Future<Either<Failure, List<Law>>> call(LawsQuery query) {
    return _repo.getLaws(query);
  }
}
