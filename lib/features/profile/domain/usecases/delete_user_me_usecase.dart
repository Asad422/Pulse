import 'package:injectable/injectable.dart';
import '../repositories/user_repository.dart';

@lazySingleton
class DeleteUserMeUseCase {
  final UserRepository _repo;
  DeleteUserMeUseCase(this._repo);

  Future<void> call() => _repo.deleteUserMe();
}
