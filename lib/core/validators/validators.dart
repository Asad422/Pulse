class AppValidators {
  static final _emailRe = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]{2,}$');
  static final _digit = RegExp(r'\d');
  static final _lower = RegExp(r'[a-z]');
  static final _upper = RegExp(r'[A-Z]');
  static final _special = RegExp(r'[!@#\$%\^&\*\-\_\+\=\.\,\:\;\?\(\)\[\]\{\}]');

  /// Возвращает текст ошибки, либо null если ок
  static String? emailError(String v) {
    final t = v.trim();
    if (t.isEmpty) return 'Enter your email';
    if (!_emailRe.hasMatch(t)) return 'Enter a valid email';
    return null;
  }

  /// Минимум 8 символов, буквы в разных регистрах, цифра, спецсимвол
  static String? passwordError(String v) {
    if (v.isEmpty) return 'Enter a password';
    if (v.length < 8) return 'At least 8 characters';
    if (!_lower.hasMatch(v)) return 'Add a lowercase letter';
    if (!_upper.hasMatch(v)) return 'Add an uppercase letter';
    if (!_digit.hasMatch(v)) return 'Add a number';
    if (!_special.hasMatch(v)) return 'Add a special character';
    return null;
  }

  static String? confirmPasswordError(String pwd, String confirm) {
    if (confirm.isEmpty) return 'Repeat the password';
    if (pwd != confirm) return 'Passwords do not match';
    return null;
  }
}
