import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:pulse/core/failure/failure.dart';
import '../entities/politican_detail.dart';
import '../repositories/politicians_repository.dart';

@lazySingleton
class GetPoliticianUseCase {
  final PoliticiansRepository _repo;
  GetPoliticianUseCase(this._repo);

  Future<Either<Failure, PoliticianDetail>> call(String bioguideId) {
    return _repo.getPoliticianById(bioguideId);
  }
}
