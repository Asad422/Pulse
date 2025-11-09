import 'package:injectable/injectable.dart';
import '../entities/user_interest.dart';
import '../repositories/user_repository.dart';

@lazySingleton
class GetUserInterestsUseCase {
  final UserRepository _repo;
  GetUserInterestsUseCase(this._repo);

  Future<List<UserInterest>> call() => _repo.getUserInterests();
}
