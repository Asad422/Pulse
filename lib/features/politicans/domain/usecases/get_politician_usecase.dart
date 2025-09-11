import 'package:injectable/injectable.dart';
import '../entities/politician.dart';
import '../repositories/politicians_repository.dart';

@lazySingleton
class GetPoliticianUseCase {
  final PoliticiansRepository _repo;
  GetPoliticianUseCase(this._repo);

  Future<Politician> call(String bioguideId) {
    return _repo.getPoliticianById(bioguideId);
  }
}
