class AppRoutes {
  // Standalone
  static const onboarding = 'onboarding';
  static const login = 'login';
  static const register = 'register';
  static const location = 'location';           // NEW

  // Shell tabs
  static const home = 'home';
  static const search = 'search';
  static const profile = 'profile';

  // Legal
  static const policySafety = 'policySafety';
  static const userRights   = 'userRights';
}

class AppPaths {
  static const onboarding = '/onboarding';
  static const login = '/auth/login';
  static const register = '/auth/register';
  static const location = '/auth/location';     // NEW

  static const home = '/app/home';
  static const search = '/app/search';
  static const profile = '/app/profile';

  static const policySafety = '/legal/policy-safety';
  static const userRights   = '/legal/user-rights';
}
