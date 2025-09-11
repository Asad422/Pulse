import '../entities/politician.dart';

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

  Future<Politician> getPoliticianById(String bioguideId);

}
