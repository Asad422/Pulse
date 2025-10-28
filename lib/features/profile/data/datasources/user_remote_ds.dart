import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

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
}
