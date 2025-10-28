import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'core/localization/generated/l10n.dart';
import 'core/router/app_router.dart';
import 'app/di/di.dart'; // тут лежит sl и configureDependencies
import 'features/auth/presentation/bloc/login_bloc/login_bloc.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // инициализируем DI (injectable)
  await configureDependencies();

  runApp(
    DevicePreview(
      enabled: !kReleaseMode, // включай превью только не в релизе
      builder: (context) => const App(),
    ),
  );
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    final GoRouter router = AppRouter.create();

    return MultiBlocProvider(
      providers: [
        BlocProvider<LoginBloc>(
          create: (_) => sl<LoginBloc>(), // <-- берём из DI через sl
        ),
      ],
      child: MaterialApp.router(
        title: 'Pulse',
        debugShowCheckedModeBanner: false,
        routerConfig: router,
        theme: ThemeData(useMaterial3: true),
        useInheritedMediaQuery: true,
        locale: DevicePreview.locale(context),
        builder: DevicePreview.appBuilder,
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
