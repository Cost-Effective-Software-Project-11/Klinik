enum ConfirmPasswordValidationError { mismatch, empty }

class ConfirmPassword {
  final String originalPassword;

  const ConfirmPassword.pure({this.originalPassword = ''}) : super.pure('');
  const ConfirmPassword.dirty({required this.originalPassword, String value = ''}) : super.dirty(value);

  ConfirmPasswordValidationError? validator(String value) {
    if (value.isEmpty) {
      return ConfirmPasswordValidationError.empty;
    } else if (value != originalPassword) {
      return ConfirmPasswordValidationError.mismatch;
    }
    return null;
  }
}