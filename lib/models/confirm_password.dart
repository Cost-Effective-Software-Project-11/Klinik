enum ConfirmPasswordValidationError { mismatch, empty }

class ConfirmPassword {
  late final String originalPassword;

  ConfirmPasswordValidationError? validator(String value) {
    if (value.isEmpty) {
      return ConfirmPasswordValidationError.empty;
    } else if (value != originalPassword) {
      return ConfirmPasswordValidationError.mismatch;
    }
    return null;
  }
}