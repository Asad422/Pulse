class AppRoutes {
  // Standalone
  static const onboarding = 'onboarding';
  static const login = 'login';
  static const verifyCode = 'verifyCode';           // 👈 NEW
  static const register = 'register';
  static const location = 'location';           // NEW
  static const politician = 'politician';           // 👈 NEW
  static const splash = 'splash';
  static const profileSetup = 'profileSetup'; // ✅ добавили


  // Shell tabs
  static const home = 'home';
  static const politicians = 'politicians';
  static const profile = 'profile';
  static const bills = 'bills'; // 👈 NEW
  static const billDetail = 'billDetail';
  static const lawDetail = 'lawDetail';
  static const activity = 'activity';
  static const profileEdit = 'profileEdit';


  // Legal
  static const policySafety = 'policySafety';
  static const userRights   = 'userRights';
  static const language = 'language';
}


class AppPaths {
  static const onboarding = '/onboarding';
  static const login = '/auth/login';
  static const register = '/auth/register';
  static const location = '/auth/location';     // NEW
  static const politician = '/app/politicians/:id'; // 👈 NEW
  static const verifyCode = '/auth/verifyCode';           // 👈 NEW
  static const splash = '/splash';
  static const profileSetup = '/auth/profile/setup'; // ✅ новый путь
  static const profileEdit = '/app/profile/edit';
  

  static const home = '/app/home';
  static const politicians = '/app/politicians';
  static const profile = '/app/profile';
  static const bills = '/app/bills'; // 👈 NEW
  static const billDetail = '/app/bills/:id';
  static const lawDetail = '/app/home/law/:id';
   


  static const policySafety = '/legal/policy-safety';
  static const userRights   = '/legal/user-rights';
  static const activity = '/app/profile/activity';
  static const language = '/app/profile/language';
}
