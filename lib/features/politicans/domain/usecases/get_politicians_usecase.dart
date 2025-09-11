import 'package:injectable/injectable.dart';
import '../entities/politician.dart';
import '../repositories/politicians_repository.dart';

@lazySingleton
class GetPoliticiansUseCase {
  final PoliticiansRepository _repo;
  GetPoliticiansUseCase(this._repo);

  Future<List<Politician>> call(PoliticiansQuery query) {
    return _repo.getPoliticians(query);
  }
}
