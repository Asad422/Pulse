import 'package:go_router/go_router.dart';
import 'package:pulse/features/legislation/presentation/screens/legislation_screen.dart';
import 'package:pulse/features/politicans/presentation/screens/politicans_screen.dart';
import '../../app/ui/shell/app_shell.dart';
import '../../features/auth/presentation/screens/location_select_screen.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/register_screen.dart';
import '../../features/onboarding/onboarding_screen.dart';
import '../../features/privacy_policy/presentation/screens/policy_safety_screen.dart';
import '../../features/privacy_policy/presentation/screens/user_rights_screen.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';
import 'routes.dart';

class AppRouter {
  static GoRouter create() {
    return GoRouter(
      initialLocation: AppPaths.onboarding,
      routes: [
        // Standalone
        GoRoute(
          path: AppPaths.onboarding,
          name: AppRoutes.onboarding,
          builder: (c, s) => const OnboardingScreen(),
        ),
        GoRoute(
          path: AppPaths.login,
          name: AppRoutes.login,
          builder: (c, s) => const LoginScreen(),
        ),
        GoRoute(
          path: AppPaths.register,
          name: AppRoutes.register,
          builder: (c, s) => const RegisterScreen(),
        ),
        GoRoute(
          path: AppPaths.location,
          name: AppRoutes.location,
          builder: (c, s) => LocationSelectScreen(
            initialSelected: s.extra as String?,
          ),
        ),


        // Legal
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

        // App shell with bottom navigation
        ShellRoute(
          builder: (c, s, child) => AppShell(child: child),
          routes: [
            GoRoute(
              path: AppPaths.home,
              name: AppRoutes.home,
              pageBuilder: (c, s) => const NoTransitionPage(child: LegislationScreen()),
            ),
            GoRoute(
              path: AppPaths.search,
              name: AppRoutes.search,
              pageBuilder: (c, s) => const NoTransitionPage(child: PoliticansScreen()),
            ),
            GoRoute(
              path: AppPaths.profile,
              name: AppRoutes.profile,
              pageBuilder: (c, s) => const NoTransitionPage(child: ProfileScreen()),
            ),
          ],
        ),
      ],
    );
  }
}
