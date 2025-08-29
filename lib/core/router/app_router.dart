import 'package:go_router/go_router.dart';
import 'routes.dart';

// shell

// screens
import '../../../features/onboarding/onboarding_screen.dart';
import '../../app/ui/shell/app_shell.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/register_screen.dart';
import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';
import '../../features/search/presentation/screens/search_screen.dart';

class AppRouter {
  static GoRouter create() {
    return GoRouter(
      initialLocation: AppPaths.onboarding, // без проверок, просто стартуем тут
      routes: [
        GoRoute(
          path: AppPaths.onboarding,
          name: AppRoutes.onboarding,
          builder: (ctx, st) => const OnboardingScreen(),
        ),
        GoRoute(
          path: AppPaths.login,
          name: AppRoutes.login,
          builder: (ctx, st) => const LoginScreen(),
        ),
        GoRoute(
          path: AppPaths.register,
          name: AppRoutes.register,
          builder: (ctx, st) => const RegisterScreen(),
        ),

        // Shell с нижним баром на 3 экрана
        ShellRoute(
          builder: (ctx, st, child) => AppShell(child: child),
          routes: [
            GoRoute(
              path: AppPaths.home,
              name: AppRoutes.home,
              pageBuilder: (ctx, st) => const NoTransitionPage(child: HomeScreen()),
            ),
            GoRoute(
              path: AppPaths.search,
              name: AppRoutes.search,
              pageBuilder: (ctx, st) => const NoTransitionPage(child: SearchScreen()),
            ),
            GoRoute(
              path: AppPaths.profile,
              name: AppRoutes.profile,
              pageBuilder: (ctx, st) => const NoTransitionPage(child: ProfileScreen()),
            ),
          ],
        ),
      ],
    );
  }
}
