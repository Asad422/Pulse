import '../entities/politician.dart';
import '../entities/politican_detail.dart';
import '../entities/politicians_query.dart';

abstract class PoliticiansRepository {
  Future<List<Politician>> getPoliticians(PoliticiansQuery query);
  Future<PoliticianDetail> getPoliticianById(String bioguideId);
}
