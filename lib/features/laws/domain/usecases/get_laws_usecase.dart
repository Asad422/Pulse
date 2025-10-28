import 'package:injectable/injectable.dart';
import '../entities/law.dart';
import '../entities/laws_query.dart';
import '../repositories/laws_repository.dart';

@lazySingleton
class GetLawsUseCase {
  final LawsRepository _repo;
  GetLawsUseCase(this._repo);

  Future<List<Law>> call(LawsQuery query) {
    return _repo.getLaws(query);
  }
}
