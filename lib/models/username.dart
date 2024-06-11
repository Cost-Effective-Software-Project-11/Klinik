enum UsernameValidationError { empty }

class Username {
  @override
  UsernameValidationError? validator(String value) {
    if (value.isEmpty) return UsernameValidationError.empty;
    return null;
  }
}
