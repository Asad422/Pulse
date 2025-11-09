import '../entities/subject.dart';
import '../entities/user.dart';
import '../entities/user_interest.dart';

abstract class UserRepository {
  Future<User> getUserMe();
  Future<User> updateUserMe({
    required String login,
    required Profile profile,
  });
  Future<void> deleteUserMe();
  Future<List<UserInterest>> getUserInterests();
  Future<List<Subject>> getSubjects();

}
