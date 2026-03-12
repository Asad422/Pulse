import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:pulse/core/failure/failure.dart';
import '../entities/law_poll_query.dart';
import '../repositories/laws_repository.dart';

@lazySingleton
class VoteForLawUseCase {
  final LawsRepository _repo;
  VoteForLawUseCase(this._repo);

  Future<Either<Failure, void>> call(LawPollQuery query) {
    return _repo.voteForLaw(query);
  }
}
