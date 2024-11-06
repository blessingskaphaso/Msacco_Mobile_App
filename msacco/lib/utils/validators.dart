class Validators {
  static String? validateEmail(String email) {
    final regex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return regex.hasMatch(email) ? null : 'Enter a valid email';
  }

  static String? validatePassword(String password) {
    return password.length >= 6
        ? null
        : 'Password must be at least 6 characters';
  }
}
