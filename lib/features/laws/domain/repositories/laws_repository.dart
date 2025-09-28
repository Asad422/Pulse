import '../entities/law.dart';

abstract class LawsRepository {
  Future<List<Law>> getLaws({
    int? congress,
    String? lawType,
    String? lawNumber,
    int? billId,
  });

  Future<Law> getLaw(int lawId);

  Future<Law> getLawByIdentity({
    required int congress,
    required String lawType,
    required String lawNumber,
  });
}
