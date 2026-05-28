
class Validators {
  Validators._();

  static bool isValidEmail(String email) =>
      RegExp(r'^[a-zA-Z0-9._%+\-]+@[a-zA-Z0-9.\-]+\.[a-zA-Z]{2,}$')
          .hasMatch(email.trim());

  static bool isValidPhone(String phone) => phone.trim().length == 17;

  static bool isValidPassword(String password) => password.length >= 8;

  static bool isValidUsername(String username) =>
      RegExp(r'^[a-zA-Z0-9_.]{4,30}$').hasMatch(username.trim());

  static bool isValidFullName(String name) =>
      name.trim().split(RegExp(r'\s+')).length >= 2;


  static String? emailError(String email) {
    if (email.isEmpty) return 'Email is required';
    if (!isValidEmail(email)) return 'Enter a valid email address';
    return null;
  }

  static String? phoneError(String phone) {
    if (!isValidPhone(phone)) return 'Enter a complete phone number';
    return null;
  }

  static String? passwordError(String password) {
    if (password.isEmpty) return 'Password is required';
    if (!isValidPassword(password)) return 'Password must be at least 8 characters';
    return null;
  }

  static String? usernameError(String username) {
    if (username.isEmpty) return 'Username is required';
    if (!isValidUsername(username)) {
      return 'Username: 4–30 characters, only letters, digits, _ and .';
    }
    return null;
  }

  static String? fullNameError(String name) {
    if (name.isEmpty) return 'Name is required';
    if (!isValidFullName(name)) return 'Enter your first and last name';
    return null;
  }
}
