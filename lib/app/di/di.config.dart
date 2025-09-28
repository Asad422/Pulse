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
import '../../features/auth/domain/usecases/refresh_token_usecase.dart'
    as _i157;
import '../../features/auth/domain/usecases/request_otp_usecase.dart' as _i29;
import '../../features/auth/domain/usecases/verify_otp_usecase.dart' as _i503;
import '../../features/auth/presentation/bloc/login_bloc/login_bloc.dart'
    as _i450;
import '../../features/bills/data/datasources/bills_remote_ds.dart' as _i826;
import '../../features/bills/data/repositories/bills_repository_impl.dart'
    as _i480;
import '../../features/bills/domain/repositories/bills_repository.dart'
    as _i468;
import '../../features/bills/domain/usecases/get_bill_usecase.dart' as _i535;
import '../../features/bills/domain/usecases/get_bills_usecase.dart' as _i264;
import '../../features/laws/data/datasources/laws_remote_ds.dart' as _i422;
import '../../features/laws/data/repositories/laws_repository_impl.dart'
    as _i80;
import '../../features/laws/domain/repositories/laws_repository.dart' as _i114;
import '../../features/laws/domain/usecases/get_law_by_identity_usecase.dart'
    as _i1051;
import '../../features/laws/domain/usecases/get_law_usecase.dart' as _i334;
import '../../features/laws/domain/usecases/get_laws_usecase.dart' as _i461;
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
  gh.lazySingleton<_i558.FlutterSecureStorage>(() => externalModule.storage);
  gh.factory<String>(
    () => networkModule.baseUrl,
    instanceName: 'baseUrl',
  );
  gh.lazySingleton<_i356.TokenStorage>(
      () => _i103.SecureTokenStorage(gh<_i558.FlutterSecureStorage>()));
  gh.lazySingleton<_i361.Dio>(
    () => networkModule.plainMainDio(gh<String>(instanceName: 'baseUrl')),
    instanceName: 'plainMainDio',
  );
  gh.lazySingleton<_i388.AuthInterceptor>(() => _i388.AuthInterceptor(
        gh<_i361.Dio>(instanceName: 'plainMainDio'),
        gh<_i356.TokenStorage>(),
      ));
  gh.lazySingleton<_i361.Dio>(
    () => networkModule.authDio(
      gh<String>(instanceName: 'baseUrl'),
      gh<_i388.AuthInterceptor>(),
    ),
    instanceName: 'authDio',
  );
  gh.lazySingleton<_i626.AuthRemoteDataSource>(
      () => _i626.AuthRemoteDataSource(gh<_i361.Dio>(instanceName: 'authDio')));
  gh.lazySingleton<_i422.LawsRemoteDataSource>(
      () => _i422.LawsRemoteDataSource(gh<_i361.Dio>(instanceName: 'authDio')));
  gh.lazySingleton<_i153.PoliticiansRemoteDataSource>(() =>
      _i153.PoliticiansRemoteDataSource(
          gh<_i361.Dio>(instanceName: 'authDio')));
  gh.lazySingleton<_i826.BillsRemoteDataSource>(() =>
      _i826.BillsRemoteDataSource(gh<_i361.Dio>(instanceName: 'authDio')));
  gh.lazySingleton<_i114.LawsRepository>(
      () => _i80.LawsRepositoryImpl(gh<_i422.LawsRemoteDataSource>()));
  gh.lazySingleton<_i460.PoliticiansRepository>(() =>
      _i132.PoliticiansRepositoryImpl(gh<_i153.PoliticiansRemoteDataSource>()));
  gh.lazySingleton<_i787.AuthRepository>(
      () => _i153.AuthRepositoryImpl(gh<_i626.AuthRemoteDataSource>()));
  gh.lazySingleton<_i468.BillsRepository>(
      () => _i480.BillsRepositoryImpl(gh<_i826.BillsRemoteDataSource>()));
  gh.lazySingleton<_i696.GetPoliticianUseCase>(
      () => _i696.GetPoliticianUseCase(gh<_i460.PoliticiansRepository>()));
  gh.lazySingleton<_i953.GetPoliticiansUseCase>(
      () => _i953.GetPoliticiansUseCase(gh<_i460.PoliticiansRepository>()));
  gh.lazySingleton<_i334.GetLawUseCase>(
      () => _i334.GetLawUseCase(gh<_i114.LawsRepository>()));
  gh.lazySingleton<_i461.GetLawsUseCase>(
      () => _i461.GetLawsUseCase(gh<_i114.LawsRepository>()));
  gh.lazySingleton<_i1051.GetLawByIdentityUseCase>(
      () => _i1051.GetLawByIdentityUseCase(gh<_i114.LawsRepository>()));
  gh.lazySingleton<_i535.GetBillUseCase>(
      () => _i535.GetBillUseCase(gh<_i468.BillsRepository>()));
  gh.lazySingleton<_i264.GetBillsUseCase>(
      () => _i264.GetBillsUseCase(gh<_i468.BillsRepository>()));
  gh.lazySingleton<_i157.RefreshTokenUseCase>(
      () => _i157.RefreshTokenUseCase(gh<_i787.AuthRepository>()));
  gh.lazySingleton<_i29.RequestOtpUseCase>(
      () => _i29.RequestOtpUseCase(gh<_i787.AuthRepository>()));
  gh.lazySingleton<_i503.VerifyOtpUseCase>(
      () => _i503.VerifyOtpUseCase(gh<_i787.AuthRepository>()));
  gh.factory<_i450.LoginBloc>(() => _i450.LoginBloc(
        requestOtpUseCase: gh<_i29.RequestOtpUseCase>(),
        verifyOtpUseCase: gh<_i503.VerifyOtpUseCase>(),
        tokenStorage: gh<_i356.TokenStorage>(),
      ));
  return getIt;
}

class _$ExternalModule extends _i489.ExternalModule {}

class _$NetworkModule extends _i567.NetworkModule {}
