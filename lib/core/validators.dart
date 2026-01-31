class Validators {
  static bool isEmailValid(String v) {
    final r = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    return r.hasMatch(v.trim());
  }

  static bool hasUpper(String v) => RegExp(r'[A-Z]').hasMatch(v);
  static bool hasLower(String v) => RegExp(r'[a-z]').hasMatch(v);
  static bool hasNumber(String v) => RegExp(r'[0-9]').hasMatch(v);
  static bool min8(String v) => v.length >= 8;
}
