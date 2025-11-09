import 'package:injectable/injectable.dart';
import '../../domain/entities/subject.dart';
import '../../domain/entities/user.dart';
import '../../domain/entities/user_interest.dart';
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
        'sex': profile.sex,
        'address_city': profile.addressCity,
      },
    };
    return _ds.updateUserMe(body);
  }

  @override
  Future<void> deleteUserMe() => _ds.deleteUserMe();


  @override
  Future<List<UserInterest>> getUserInterests() async {
    final models = await _ds.getUserInterests();
    return models
        .map((m) => UserInterest(
      id: m.id,
      userProfileId: m.userProfileId,
      subjectId: m.subjectId,
    ))
        .toList();
  }

  @override
  Future<List<Subject>> getSubjects() async {
    final models = await _ds.getSubjects();
    return models.map((m) => Subject(id: m.id, name: m.name)).toList();
  }
}
