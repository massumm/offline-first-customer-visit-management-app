class AppValidator{
  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return "Email is required";
    }
    // Basic email format validation using a regular expression
    // This is a common, though not exhaustive, regex for email validation.
    // For stricter validation, you might consider a more complex regex or a package.
    String pattern =
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
    RegExp regex = RegExp(pattern);
    if (!regex.hasMatch(value)) {
      return "Enter a valid email address";
    }
    return null; // Return null if validation passes
  }

  String? validatePassword(String? password, {String? email}) {
    if (password == null || password.isEmpty) {
      return "Password is required";
    }
    if (password.length < 8) {
      return "Password must be at least 8 characters long";
    }
    final numericRegex = RegExp(r'^[0-9]+$');
    if (numericRegex.hasMatch(password)) {
      return "Password cannot consist entirely of digits.";
    }

    // For a production app, consider using a service or a more extensive,
    // securely stored list of common passwords.
    const commonPasswords = {
      '12345678',
      'password',
      '123456',
      '123456789',
      'qwerty',
      '111111',
      'p@ssword',
      'admin'
    };

    if (commonPasswords.contains(password.toLowerCase())) {
      return "Password is too common. Please choose a stronger one.";
    }

    if (email != null && email.isNotEmpty) {
      final username = email.split('@').first;
      // Avoid flagging short usernames that might appear in many words.
      if (username.length > 3 && password.toLowerCase().contains(username.toLowerCase())) {
        return "Password cannot be too similar to your email.";
      }
    }

    return null; // Return null if validation passes
  }
}