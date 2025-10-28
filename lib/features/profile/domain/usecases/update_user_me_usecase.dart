import 'package:injectable/injectable.dart';
import '../entities/user.dart';
import '../repositories/user_repository.dart';

@lazySingleton
class UpdateUserMeUseCase {
  final UserRepository _repo;
  UpdateUserMeUseCase(this._repo);

  Future<User> call({
    required String login,
    required Profile profile,
  }) =>
      _repo.updateUserMe(login: login, profile: profile);
}
