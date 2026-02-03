class AppValidator {
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter an email';
    }

    RegExp emailRegExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegExp.hasMatch(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  static String? validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a phone number';
    }
    if (value.length < 10) {
      return 'Please enter a valid phone number';
    }
    return null;
  }

  static String? validatePhone(String? value) {
    return validatePhoneNumber(value);
  }

  static String? validateField(String? value) {
    if (value == null || value.isEmpty) {
      return 'This field cannot be empty';
    }
    return null;
  }

  static String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a name';
    }
    if (value.length < 2) {
      return 'Name must be at least 2 characters';
    }
    return null;
  }

  static String? validateAge(int? value) {
    if (value == null) {
      return 'Please enter a valid age';
    }
    if (value < 13 || value > 120) {
      return 'Age must be between 13 and 120';
    }
    return null;
  }

  static String? validateWeight(double? value) {
    if (value == null) {
      return 'Please enter a valid weight';
    }
    if (value < 30 || value > 300) {
      return 'Weight must be between 30 and 300 kg';
    }
    return null;
  }

  static String? validateHeight(int? value) {
    if (value == null) {
      return 'Please enter a valid height';
    }
    if (value < 100 || value > 250) {
      return 'Height must be between 100 and 250 cm';
    }
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a password';
    }

    final passwordRegex = RegExp(
      r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[!@#$%^&*(),.?":{}|<>]).{8,}$',
    );

    if (!passwordRegex.hasMatch(value)) {
      return 'Password must be 8 chars, with all types.';
    }

    return null;
  }

  static String? validateUsername(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a username';
    }
    if (value.length < 3) {
      return 'Username must be at least 3 characters';
    }
    return null;
  }
}
