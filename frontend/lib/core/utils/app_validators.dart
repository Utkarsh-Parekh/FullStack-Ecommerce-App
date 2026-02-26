class AppValidators {

  static String? nameValidator(String? value) {
    if (value == null || value.isEmpty) {
      return "Please Enter your full name";
    }
    return null;
  }

  static String? emailValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please Enter your Email Id';
    }

    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );

    if (!emailRegex.hasMatch(value)) {
      return 'Enter a valid email address';
    }

    return null;
  }

  static String? passwordValidator(String? value) {
    if (value!.isEmpty) {
      return "Please enter valid Password";
    }
    if (value.length < 6) {
      return "Password must be at least 6 character long";
    }
    return null;
  }

}