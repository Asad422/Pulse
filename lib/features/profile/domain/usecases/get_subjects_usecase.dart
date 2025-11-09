import 'package:injectable/injectable.dart';
import '../entities/subject.dart';
import '../repositories/user_repository.dart';

@lazySingleton
class GetSubjectsUseCase {
  final UserRepository _repository;
  GetSubjectsUseCase(this._repository);

  Future<List<Subject>> call({int skip = 0, int limit = 100}) {
    return _repository.getSubjects();
  }
}
