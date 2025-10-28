import 'package:injectable/injectable.dart';
import '../entities/user.dart';
import '../repositories/user_repository.dart';

@lazySingleton
class GetUserMeUseCase {
  final UserRepository _repo;
  GetUserMeUseCase(this._repo);

  Future<User> call() => _repo.getUserMe();
}
