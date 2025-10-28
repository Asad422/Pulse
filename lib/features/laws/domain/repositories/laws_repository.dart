import '../entities/law.dart';
import '../entities/laws_query.dart';

abstract class LawsRepository {
  Future<List<Law>> getLaws(LawsQuery query);
  Future<Law> getLaw(int lawId);
  Future<Law> getLawByIdentity({
    required int congress,
    required String lawType,
    required String lawNumber,
  });
}
