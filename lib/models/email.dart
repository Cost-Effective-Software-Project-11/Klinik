enum EmailValidationError { invalid, empty }

class Email {
  EmailValidationError? validator(String value) {
    if (value.isEmpty) {
      return EmailValidationError.empty;
    } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+$').hasMatch(value)) {
      return EmailValidationError.invalid;
    }
    return null;
  }
}