import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:pulse/features/profile/data/models/profile_enums_model.dart';
import 'package:pulse/features/profile/data/models/vote_history_model.dart';

import '../models/subject_model.dart';
import '../models/user_interest_model.dart';
import '../models/user_model.dart';

@lazySingleton
class UserRemoteDataSource {
  final Dio _dio;

  UserRemoteDataSource(@Named('authDio') this._dio);

  Future<UserModel> getUserMe() async {
    final resp = await _dio.get('/users/me');
    return UserModel.fromJson(resp.data as Map<String, dynamic>);
  }

  Future<UserModel> updateUserMe(Map<String, dynamic> body) async {
    final resp = await _dio.put('/users/me', data: body);
    return UserModel.fromJson(resp.data as Map<String, dynamic>);
  }

  Future<void> deleteUserMe() async {
    await _dio.delete('/users/me');
  }

  Future<List<UserInterestModel>> getUserInterests() async {
    final resp = await _dio.get('/subjects/user-interests/me');
    final data = resp.data as List<dynamic>;
    return data
        .map((e) => UserInterestModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<List<SubjectModel>> getSubjects({
    int skip = 0,
    int limit = 100,
  }) async {
    final resp = await _dio.get(
      '/subjects/',
      queryParameters: {'skip': skip, 'limit': limit},
    );
    final data = resp.data as List<dynamic>;
    return data
        .map((e) => SubjectModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<List<VoteHistoryModel>> getVoteHistory() async {
    final resp = await _dio.get('/polls/votes');
    final data = resp.data as List<dynamic>;
    return data
        .map((e) => VoteHistoryModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<void> addUserInterest(int subjectId) async {
    await _dio.post('/subjects/$subjectId/user-interests');
  }

  Future<ProfileEnumsModel> getProfileEnums() async {
    final resp = await _dio.get('/users/profile/enums');
    return ProfileEnumsModel.fromJson(resp.data as Map<String, dynamic>);
  }
}
