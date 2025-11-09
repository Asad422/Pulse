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
import '../../core/network/data/datasources/polls_remote_datasource.dart'
    as _i547;
import '../../core/network/data/repositories/polls_repository_impl.dart'
    as _i151;
import '../../core/network/domain/repositories/polls_repository.dart' as _i19;
import '../../core/network/domain/usecases/create_vote_usecase.dart' as _i258;
import '../../core/network/domain/usecases/delete_all_votes_usecase.dart'
    as _i145;
import '../../core/network/domain/usecases/delete_vote_usecase.dart' as _i7;
import '../../core/network/domain/usecases/get_my_votes_usecase.dart' as _i551;
import '../../core/network/domain/usecases/get_poll_detail_usecase.dart'
    as _i75;
import '../../core/network/domain/usecases/get_polls_usecase.dart' as _i140;
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
import '../../features/bills/domain/usecases/download_bill_text_usecase.dart'
    as _i70;
import '../../features/bills/domain/usecases/get_bill_amendments_usecase.dart'
    as _i863;
import '../../features/bills/domain/usecases/get_bill_crs_reports_usecase.dart'
    as _i374;
import '../../features/bills/domain/usecases/get_bill_sponsors_usecase.dart'
    as _i240;
import '../../features/bills/domain/usecases/get_bill_text_usecase.dart'
    as _i512;
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
import '../../features/politicans/presentation/bloc/politicians_bloc/politicians_bloc.dart'
    as _i143;
import '../../features/profile/data/datasources/user_remote_ds.dart' as _i800;
import '../../features/profile/data/repositories/user_repository_impl.dart'
    as _i938;
import '../../features/profile/domain/repositories/user_repository.dart'
    as _i146;
import '../../features/profile/domain/usecases/delete_user_me_usecase.dart'
    as _i955;
import '../../features/profile/domain/usecases/get_subjects_usecase.dart'
    as _i270;
import '../../features/profile/domain/usecases/get_user_interests_usecase.dart'
    as _i623;
import '../../features/profile/domain/usecases/get_user_me_usecase.dart'
    as _i1003;
import '../../features/profile/domain/usecases/update_user_me_usecase.dart'
    as _i220;
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
  gh.lazySingleton<_i800.UserRemoteDataSource>(
      () => _i800.UserRemoteDataSource(gh<_i361.Dio>(instanceName: 'authDio')));
  gh.lazySingleton<_i547.PollsRemoteDataSource>(() =>
      _i547.PollsRemoteDataSource(gh<_i361.Dio>(instanceName: 'authDio')));
  gh.lazySingleton<_i114.LawsRepository>(
      () => _i80.LawsRepositoryImpl(gh<_i422.LawsRemoteDataSource>()));
  gh.lazySingleton<_i460.PoliticiansRepository>(() =>
      _i132.PoliticiansRepositoryImpl(gh<_i153.PoliticiansRemoteDataSource>()));
  gh.lazySingleton<_i787.AuthRepository>(
      () => _i153.AuthRepositoryImpl(gh<_i626.AuthRemoteDataSource>()));
  gh.lazySingleton<_i468.BillsRepository>(
      () => _i480.BillsRepositoryImpl(gh<_i826.BillsRemoteDataSource>()));
  gh.lazySingleton<_i19.PollsRepository>(
      () => _i151.PollsRepositoryImpl(gh<_i547.PollsRemoteDataSource>()));
  gh.lazySingleton<_i696.GetPoliticianUseCase>(
      () => _i696.GetPoliticianUseCase(gh<_i460.PoliticiansRepository>()));
  gh.lazySingleton<_i953.GetPoliticiansUseCase>(
      () => _i953.GetPoliticiansUseCase(gh<_i460.PoliticiansRepository>()));
  gh.lazySingleton<_i146.UserRepository>(
      () => _i938.UserRepositoryImpl(gh<_i800.UserRemoteDataSource>()));
  gh.lazySingleton<_i334.GetLawUseCase>(
      () => _i334.GetLawUseCase(gh<_i114.LawsRepository>()));
  gh.lazySingleton<_i461.GetLawsUseCase>(
      () => _i461.GetLawsUseCase(gh<_i114.LawsRepository>()));
  gh.lazySingleton<_i1051.GetLawByIdentityUseCase>(
      () => _i1051.GetLawByIdentityUseCase(gh<_i114.LawsRepository>()));
  gh.lazySingleton<_i70.DownloadBillTextUseCase>(
      () => _i70.DownloadBillTextUseCase(gh<_i468.BillsRepository>()));
  gh.lazySingleton<_i863.GetBillAmendmentsUseCase>(
      () => _i863.GetBillAmendmentsUseCase(gh<_i468.BillsRepository>()));
  gh.lazySingleton<_i374.GetBillCrsReportsUseCase>(
      () => _i374.GetBillCrsReportsUseCase(gh<_i468.BillsRepository>()));
  gh.lazySingleton<_i240.GetBillSponsorsUseCase>(
      () => _i240.GetBillSponsorsUseCase(gh<_i468.BillsRepository>()));
  gh.lazySingleton<_i512.GetBillTextUseCase>(
      () => _i512.GetBillTextUseCase(gh<_i468.BillsRepository>()));
  gh.lazySingleton<_i535.GetBillUseCase>(
      () => _i535.GetBillUseCase(gh<_i468.BillsRepository>()));
  gh.lazySingleton<_i264.GetBillsUseCase>(
      () => _i264.GetBillsUseCase(gh<_i468.BillsRepository>()));
  gh.lazySingleton<_i955.DeleteUserMeUseCase>(
      () => _i955.DeleteUserMeUseCase(gh<_i146.UserRepository>()));
  gh.lazySingleton<_i623.GetUserInterestsUseCase>(
      () => _i623.GetUserInterestsUseCase(gh<_i146.UserRepository>()));
  gh.lazySingleton<_i1003.GetUserMeUseCase>(
      () => _i1003.GetUserMeUseCase(gh<_i146.UserRepository>()));
  gh.lazySingleton<_i220.UpdateUserMeUseCase>(
      () => _i220.UpdateUserMeUseCase(gh<_i146.UserRepository>()));
  gh.lazySingleton<_i270.GetSubjectsUseCase>(
      () => _i270.GetSubjectsUseCase(gh<_i146.UserRepository>()));
  gh.lazySingleton<_i157.RefreshTokenUseCase>(
      () => _i157.RefreshTokenUseCase(gh<_i787.AuthRepository>()));
  gh.lazySingleton<_i29.RequestOtpUseCase>(
      () => _i29.RequestOtpUseCase(gh<_i787.AuthRepository>()));
  gh.lazySingleton<_i503.VerifyOtpUseCase>(
      () => _i503.VerifyOtpUseCase(gh<_i787.AuthRepository>()));
  gh.lazySingleton<_i140.GetPollsUseCase>(
      () => _i140.GetPollsUseCase(gh<_i19.PollsRepository>()));
  gh.lazySingleton<_i75.GetPollDetailUseCase>(
      () => _i75.GetPollDetailUseCase(gh<_i19.PollsRepository>()));
  gh.lazySingleton<_i7.DeleteVoteUseCase>(
      () => _i7.DeleteVoteUseCase(gh<_i19.PollsRepository>()));
  gh.lazySingleton<_i145.DeleteAllVotesUseCase>(
      () => _i145.DeleteAllVotesUseCase(gh<_i19.PollsRepository>()));
  gh.lazySingleton<_i551.GetMyVotesUseCase>(
      () => _i551.GetMyVotesUseCase(gh<_i19.PollsRepository>()));
  gh.lazySingleton<_i258.CreateVoteUseCase>(
      () => _i258.CreateVoteUseCase(gh<_i19.PollsRepository>()));
  gh.factory<_i450.LoginBloc>(() => _i450.LoginBloc(
        requestOtpUseCase: gh<_i29.RequestOtpUseCase>(),
        verifyOtpUseCase: gh<_i503.VerifyOtpUseCase>(),
        tokenStorage: gh<_i356.TokenStorage>(),
      ));
  gh.factory<_i143.PoliticiansBloc>(() => _i143.PoliticiansBloc(
        gh<_i953.GetPoliticiansUseCase>(),
        gh<_i258.CreateVoteUseCase>(),
      ));
  return getIt;
}

class _$ExternalModule extends _i489.ExternalModule {}

class _$NetworkModule extends _i567.NetworkModule {}
