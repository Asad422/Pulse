import 'package:injectable/injectable.dart';
import '../../domain/entities/politician.dart';
import '../../domain/repositories/politicians_repository.dart';

class GetPoliticianParams {
  final String bioguideId;
  const GetPoliticianParams(this.bioguideId);
}

@lazySingleton
class GetPoliticianUseCase {
  final PoliticiansRepository _repo;
  GetPoliticianUseCase(this._repo);

  Future<Politician> call(GetPoliticianParams params) {
    return _repo.getPoliticianById(params.bioguideId);
  }
}
