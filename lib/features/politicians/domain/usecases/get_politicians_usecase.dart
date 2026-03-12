import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:pulse/core/failure/failure.dart';
import '../entities/politician.dart';
import '../entities/politicians_query.dart';
import '../repositories/politicians_repository.dart';

@lazySingleton
class GetPoliticiansUseCase {
  final PoliticiansRepository _repo;
  GetPoliticiansUseCase(this._repo);

  Future<Either<Failure, List<Politician>>> call(PoliticiansQuery query) {
    return _repo.getPoliticians(query);
  }
}
