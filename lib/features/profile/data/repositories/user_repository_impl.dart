import 'package:injectable/injectable.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/user_repository.dart';
import '../datasources/user_remote_ds.dart';
import '../models/user_model.dart';

@LazySingleton(as: UserRepository)
class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSource _ds;
  UserRepositoryImpl(this._ds);

  @override
  Future<User> getUserMe() => _ds.getUserMe();

  @override
  Future<User> updateUserMe({
    required String login,
    required Profile profile,
  }) {
    final body = {
      'login': login,
      'profile': {
        'name': profile.name,
        'age_category': profile.ageCategory,
        'interest_level': profile.interestLevel,
        'address_city': profile.addressCity,
      },
    };
    return _ds.updateUserMe(body);
  }

  @override
  Future<void> deleteUserMe() => _ds.deleteUserMe();
}
