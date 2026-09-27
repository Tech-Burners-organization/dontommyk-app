class Validator {
  //=======================================================empty validator
  static String? emptyValidator(
    String? value, {
    String fieldName = 'This field',
  }) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  //=======================================================email
  static String? emailValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email is required';
    }

    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

    if (!emailRegex.hasMatch(value.trim())) {
      return 'Enter a valid email address';
    }
    return null;
  }

  //=======================================================password
  static String? passwordValidator(String? value, {int minLength = 6}) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }

    final regex = RegExp(
      r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[!@#$%^&*(),.?":{}|<>_\-+=/\\[\]~`]).{' +
          minLength.toString() +
          r',}$',
    );

    if (!regex.hasMatch(value)) {
      return 'Password must contain at least:\none uppercase letter,\none lowercase letter,\none number,\nand one special character';
    }

    return null;
  }
}
