import 'package:dartz/dartz.dart';
import 'package:pulse/core/failure/failure.dart';
import 'package:pulse/core/network/domain/entities/vote.dart';
import 'package:pulse/features/profile/domain/entities/profile_enums.dart';

import '../entities/subject.dart';
import '../entities/user.dart';
import '../entities/user_interest.dart';

abstract class UserRepository {
  Future<Either<Failure, User>> getUserMe();
  Future<Either<Failure, User>> updateUserMe({
    required String login,
    required Profile profile,
  });
  Future<Either<Failure, void>> deleteUserMe();
  Future<Either<Failure, List<UserInterest>>> getUserInterests();
  Future<Either<Failure, List<Subject>>> getSubjects();
  Future<Either<Failure, List<Vote>>> getVoteHistory();
  Future<Either<Failure, void>> addUserInterest(int subjectId);
  Future<Either<Failure, ProfileEnums>> getProfileEnums();
}
