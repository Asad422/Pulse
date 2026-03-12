import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:go_router/go_router.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'core/auth/auth_notifier.dart';
import 'core/connectivity/connectivity_bloc.dart';
import 'core/connectivity/connectivity_guard.dart';
import 'core/localization/generated/l10n.dart';
import 'core/network/token_storage.dart';
import 'core/observers/failure_bloc_observer.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'app/di/di.dart';
import 'features/auth/presentation/bloc/login_bloc/login_bloc.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

late final AuthNotifier _authNotifier;

Future<void> main() async {
  final binding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: binding);

  await dotenv.load(fileName: '.env', isOptional: true);

  await configureDependencies();

  _authNotifier = AuthNotifier(sl<TokenStorage>());
  await _authNotifier.init();
  sl.registerSingleton<AuthNotifier>(_authNotifier);

  Bloc.observer = FailureBlocObserver(
    navigatorKey: _rootNavigatorKey,
    onLogout: () async {
      await sl<TokenStorage>().clear();
      _authNotifier.setLoggedOut();
    },
  );

  runApp(
    DevicePreview(
      enabled: !kReleaseMode,
      builder: (context) => const App(),
    ),
  );
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    final GoRouter router = AppRouter.create(
      navigatorKey: _rootNavigatorKey,
      authNotifier: _authNotifier,
    );

    return MultiBlocProvider(
      providers: [
        BlocProvider<LoginBloc>(
          create: (_) => sl<LoginBloc>(),
        ),
        BlocProvider<ConnectivityBloc>(
          create: (_) => ConnectivityBloc()..add(ConnectivityStarted()),
        ),
      ],
      child: MaterialApp.router(
        title: 'Pulse',
        debugShowCheckedModeBanner: false,
        routerConfig: router,
        theme: AppTheme.light(),
        useInheritedMediaQuery: true,
        locale: DevicePreview.locale(context),
        scaffoldMessengerKey: _scaffoldMessengerKey,
        builder: (context, child) {
          return DevicePreview.appBuilder(
            context,
            ConnectivityGuard(child: child ?? const SizedBox.shrink()),
          );
        },
        localizationsDelegates: const [
          S.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: S.delegate.supportedLocales,
      ),
    );
  }
}
