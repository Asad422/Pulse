import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:pulse/core/failure/failure.dart';
import 'package:pulse/core/network/data/mapper.dart';
import 'package:pulse/core/network/domain/entities/vote.dart';
import 'package:pulse/features/profile/domain/entities/profile_enums.dart';
import '../../domain/entities/subject.dart';
import '../../domain/entities/user.dart';
import '../../domain/entities/user_interest.dart';
import '../../domain/repositories/user_repository.dart';
import '../datasources/user_remote_ds.dart';

@LazySingleton(as: UserRepository)
class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSource _ds;
  UserRepositoryImpl(this._ds);

  @override
  Future<Either<Failure, User>> getUserMe() =>
      safeCall(() => _ds.getUserMe());

  @override
  Future<Either<Failure, User>> updateUserMe({
    required String login,
    required Profile profile,
  }) =>
      safeCall(() {
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
      });

  @override
  Future<Either<Failure, void>> deleteUserMe() =>
      safeCall(() => _ds.deleteUserMe());

  @override
  Future<Either<Failure, List<UserInterest>>> getUserInterests() =>
      safeCall(() async {
        final models = await _ds.getUserInterests();
        return models
            .map((m) => UserInterest(
                  id: m.id,
                  userProfileId: m.userProfileId,
                  subjectId: m.subjectId,
                ))
            .toList();
      });

  @override
  Future<Either<Failure, List<Subject>>> getSubjects() =>
      safeCall(() async {
        final models = await _ds.getSubjects();
        return models.map((m) => Subject(id: m.id, name: m.name)).toList();
      });

  @override
  Future<Either<Failure, List<Vote>>> getVoteHistory() =>
      safeCall(() async {
        final models = await _ds.getVoteHistory();
        return models.map((m) => m.toEntity()).toList();
      });

  @override
  Future<Either<Failure, void>> addUserInterest(int subjectId) =>
      safeCall(() => _ds.addUserInterest(subjectId));

  @override
  Future<Either<Failure, ProfileEnums>> getProfileEnums() =>
      safeCall(() => _ds.getProfileEnums());
}
