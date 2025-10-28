import 'package:injectable/injectable.dart';
import '../entities/law.dart';
import '../repositories/laws_repository.dart';

@lazySingleton
class GetLawUseCase {
  final LawsRepository _repo;
  GetLawUseCase(this._repo);

  Future<Law> call(int lawId) {
    return _repo.getLaw(lawId);
  }
}
