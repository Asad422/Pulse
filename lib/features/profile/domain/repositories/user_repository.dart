import '../entities/user.dart';

abstract class UserRepository {
  Future<User> getUserMe();
  Future<User> updateUserMe({
    required String login,
    required Profile profile,
  });
  Future<void> deleteUserMe();
}
