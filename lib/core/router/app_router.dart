import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pulse/features/laws/presentation/screens/laws_screen.dart';
import 'package:pulse/features/politicians/presentation/screens/politicians_screen.dart';
import 'package:pulse/features/splash_screen/presentation/splash_screen.dart';
import '../../app/di/di.dart';
import '../../app/ui/shell/app_shell.dart';
import '../../features/bills/presentation/screens/bill_detail_screen.dart';
import '../../features/laws/presentation/screens/law_detail_screen.dart';
import '../../features/profile/presentation/bloc/user_bloc.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/register_screen.dart';
import '../../features/auth/presentation/screens/verify_code_screen.dart' show VerifyCodeScreen;
import '../../features/bills/presentation/screens/bills_screen.dart';
import '../../features/onboarding/onboarding_screen.dart';
import '../../features/politicians/presentation/screens/politician_detail_screen.dart';
import '../../features/privacy_policy/presentation/screens/policy_safety_screen.dart';
import '../../features/privacy_policy/presentation/screens/user_rights_screen.dart';
import '../../features/profile/presentation/screens/language_screen.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';
import '../../features/profile/presentation/screens/profile_setup_screen.dart';
import '../../features/profile/presentation/screens/vote_history_screen.dart';
import '../auth/auth_notifier.dart';
import 'routes.dart';

class AppRouter {
  static GoRouter create({
    required GlobalKey<NavigatorState> navigatorKey,
    required AuthNotifier authNotifier,
  }) {
    /// Public routes that don't require authentication.
    const publicPaths = {
      AppPaths.splash,
      AppPaths.onboarding,
      AppPaths.login,
      AppPaths.register,
      AppPaths.verifyCode,
      AppPaths.profileSetup,
      AppPaths.policySafety,
      AppPaths.userRights,
    };

    return GoRouter(
      navigatorKey: navigatorKey,
      initialLocation: AppPaths.splash,
      refreshListenable: authNotifier,

      redirect: (context, state) {
        final loggedIn = authNotifier.isLoggedIn;
        final currentPath = state.uri.toString();

        // Splash handles its own logic — never redirect away from it
        if (currentPath == AppPaths.splash) return null;

        final isPublic = publicPaths.any((p) => currentPath.startsWith(p));

        if (!loggedIn && !isPublic) {
          return AppPaths.login;
        }

        if (loggedIn && (currentPath == AppPaths.login || currentPath == AppPaths.onboarding)) {
          return AppPaths.politicians;
        }

        return null;
      },

      routes: [
        // ==== Standalone ====
        GoRoute(
          path: AppPaths.onboarding,
          name: AppRoutes.onboarding,
          builder: (c, s) => const OnboardingScreen(),
        ),
        GoRoute(
          path: AppPaths.splash,
          name: AppRoutes.splash,
          builder: (c, s) => const SplashScreen(),
        ),
        GoRoute(
          path: AppPaths.login,
          name: AppRoutes.login,
          builder: (c, s) => const LoginScreen(),
        ),
        GoRoute(
          path: AppPaths.verifyCode,
          builder: (ctx, state) {
            final email = (state.extra as Map?)?['email'] as String? ?? '';
            return VerifyCodeScreen(email: email);
          },
        ),
        GoRoute(
          path: AppPaths.profileSetup,
          name: AppRoutes.profileSetup,
          builder: (context, state) {
            final login = state.extra as String? ?? '';
            return BlocProvider(
              create: (_) => UserBloc(sl(), sl(), sl(), sl(), sl(), sl(), sl(), sl()),
              child: ProfileSetupScreen(login: login),
            );
          },
        ),
        GoRoute(
          path: AppPaths.register,
          name: AppRoutes.register,
          builder: (c, s) => const RegisterScreen(),
        ),

        // ==== Legal ====
        GoRoute(
          path: AppPaths.policySafety,
          name: AppRoutes.policySafety,
          builder: (c, s) => const PrivacyPolicyScreen(),
        ),
        GoRoute(
          path: AppPaths.userRights,
          name: AppRoutes.userRights,
          builder: (c, s) => const UserRightsScreen(),
        ),

        // ==== Shell with Bottom Navigation ====
        ShellRoute(
          builder: (c, s, child) => AppShell(child: child),
          routes: [
            GoRoute(
              path: AppPaths.home,
              name: AppRoutes.home,
              pageBuilder: (c, s) =>
              const NoTransitionPage(child: LawsScreen()),
              routes: [
                GoRoute(
                  path: 'law/:id',
                  name: AppRoutes.lawDetail,
                  builder: (c, s) {
                    final id = s.pathParameters['id']!;
                    return LawDetailScreen(lawId: id);
                  },
                ),
              ],
            ),
            GoRoute(
              path: AppPaths.bills,
              name: AppRoutes.bills,
              pageBuilder: (c, s) =>
              const NoTransitionPage(child: BillsScreen()),
              routes: [
                GoRoute(
                  path: ':id',
                  name: AppRoutes.billDetail,
                  builder: (c, s) {
                    final id = s.pathParameters['id']!;
                    return BillDetailScreen(billId: id);
                  },
                ),
              ],
            ),
            GoRoute(
              path: AppPaths.politicians,
              name: AppRoutes.politicians,
              pageBuilder: (c, s) =>
              const NoTransitionPage(child: PoliticiansScreen()),
              routes: [
                GoRoute(
                  path: ':id',
                  name: AppRoutes.politician,
                  builder: (c, s) {
                    final id = s.pathParameters['id']!;
                    return PoliticianDetailScreen(bioguideId: id);
                  },
                ),
              ],
            ),
            GoRoute(
              path: AppPaths.profile,
              name: AppRoutes.profile,
              pageBuilder: (c, s) =>
              const NoTransitionPage(child: ProfileScreen()),
              routes: [
                GoRoute(
                  path: 'activity',
                  name: AppRoutes.activity,
                  builder: (c, s) => const VoteHistoryScreen(),
                ),
                GoRoute(
                  path: 'language',
                  name: AppRoutes.language,
                  builder: (c, s) => const LanguageScreen(),
                ),
              ],
            ),
            GoRoute(
              path: AppPaths.profileEdit,
              name: AppRoutes.profileEdit,
              builder: (context, state) {
                final loginExtra = state.extra as String?;
                final bloc = context.read<UserBloc>();
                final login = loginExtra ?? bloc.state.user?.login ?? '';
                return BlocProvider.value(
                  value: bloc,
                  child: ProfileSetupScreen(login: login),
                );
              },
            ),
          ],
        ),
      ],
    );
  }
}
