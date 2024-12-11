// core/functions/password_validation.dart
passwordValidation(password) {
  const pattern = r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{8,}$';
  return RegExp(pattern).hasMatch(password);
}