// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:dio/dio.dart' as _i361;
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as _i558;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

import '../../core/network/auth_interceptor.dart' as _i388;
import '../../core/network/secure_token_storage.dart' as _i103;
import '../../core/network/token_storage.dart' as _i356;
import '../../features/auth/data/datasourses/auth_remote_ds.dart' as _i626;
import '../../features/auth/data/repositories/auth_repository_impl.dart'
    as _i153;
import '../../features/auth/domain/repositories/auth_repository.dart' as _i787;
import '../../features/auth/domain/usecases/login_usecase.dart' as _i188;
import '../../features/politicans/data/datasources/politicians_remote_ds.dart'
    as _i153;
import '../../features/politicans/data/repositories/politicians_repository_impl.dart'
    as _i132;
import '../../features/politicans/domain/repositories/politicians_repository.dart'
    as _i460;
import '../../features/politicans/domain/usecases/get_politician_usecase.dart'
    as _i696;
import '../../features/politicans/domain/usecases/get_politicians_usecase.dart'
    as _i953;
import 'external_module.dart' as _i489;
import 'interceptor_module.dart' as _i1019;
import 'network_module.dart' as _i567;

// initializes the registration of main-scope dependencies inside of GetIt
_i174.GetIt $initGetIt(
  _i174.GetIt getIt, {
  String? environment,
  _i526.EnvironmentFilter? environmentFilter,
}) {
  final gh = _i526.GetItHelper(
    getIt,
    environment,
    environmentFilter,
  );
  final externalModule = _$ExternalModule();
  final networkModule = _$NetworkModule();
  final interceptorModule = _$InterceptorModule();
  gh.lazySingleton<_i558.FlutterSecureStorage>(() => externalModule.storage);
  gh.factory<String>(
    () => networkModule.baseUrl,
    instanceName: 'baseUrl',
  );
  gh.lazySingleton<_i361.Dio>(
    () => networkModule.authDio(gh<String>(instanceName: 'baseUrl')),
    instanceName: 'authDio',
  );
  gh.lazySingleton<_i356.TokenStorage>(
      () => _i103.SecureTokenStorage(gh<_i558.FlutterSecureStorage>()));
  gh.lazySingleton<_i626.AuthRemoteDataSource>(
      () => _i626.AuthRemoteDataSource(gh<_i361.Dio>(instanceName: 'authDio')));
  gh.lazySingleton<_i361.Dio>(
    () => networkModule.plainMainDio(gh<String>(instanceName: 'baseUrl')),
    instanceName: 'plainMainDio',
  );
  gh.lazySingleton<_i787.AuthRepository>(
      () => _i153.AuthRepositoryImpl(gh<_i626.AuthRemoteDataSource>()));
  gh.lazySingleton<_i388.AuthInterceptor>(() => _i388.AuthInterceptor(
        gh<_i361.Dio>(instanceName: 'plainMainDio'),
        gh<_i361.Dio>(instanceName: 'authDio'),
        gh<_i356.TokenStorage>(),
        gh<_i787.AuthRepository>(),
      ));
  gh.lazySingleton<_i188.LoginUseCase>(
      () => _i188.LoginUseCase(gh<_i787.AuthRepository>()));
  gh.lazySingleton<_i361.Dio>(() => interceptorModule.configuredMainDio(
        gh<_i361.Dio>(instanceName: 'plainMainDio'),
        gh<_i388.AuthInterceptor>(),
      ));
  gh.lazySingleton<_i153.PoliticiansRemoteDataSource>(
      () => _i153.PoliticiansRemoteDataSource(gh<_i361.Dio>()));
  gh.lazySingleton<_i460.PoliticiansRepository>(() =>
      _i132.PoliticiansRepositoryImpl(gh<_i153.PoliticiansRemoteDataSource>()));
  gh.lazySingleton<_i953.GetPoliticiansUseCase>(
      () => _i953.GetPoliticiansUseCase(gh<_i460.PoliticiansRepository>()));
  gh.lazySingleton<_i696.GetPoliticianUseCase>(
      () => _i696.GetPoliticianUseCase(gh<_i460.PoliticiansRepository>()));
  return getIt;
}

class _$ExternalModule extends _i489.ExternalModule {}

class _$NetworkModule extends _i567.NetworkModule {}

class _$InterceptorModule extends _i1019.InterceptorModule {}
