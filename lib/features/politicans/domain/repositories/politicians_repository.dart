import '../entities/politician.dart';
import '../entities/politican_detail.dart';

class PoliticiansQuery {
  final int skip;
  final int limit;
  final String? level; // federal/state/local
  final String? state;
  final String? party;

  const PoliticiansQuery({
    this.skip = 0,
    this.limit = 100,
    this.level,
    this.state,
    this.party,
  });
}

abstract class PoliticiansRepository {
  Future<List<Politician>> getPoliticians(PoliticiansQuery query);

  /// ✅ теперь тип возвращаемого объекта — PoliticianDetail
  Future<PoliticianDetail> getPoliticianById(String bioguideId);
}
