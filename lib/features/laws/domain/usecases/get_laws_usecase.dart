import 'package:injectable/injectable.dart';
import '../entities/law.dart';
import '../repositories/laws_repository.dart';

@lazySingleton
class GetLawsUseCase {
  final LawsRepository _repo;
  GetLawsUseCase(this._repo);

  Future<List<Law>> call({int? congress, String? lawType, String? lawNumber, int? billId}) {
    return _repo.getLaws(congress: congress, lawType: lawType, lawNumber: lawNumber, billId: billId);
  }
}
