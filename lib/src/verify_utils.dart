part of muka;

class VerifyUtils {
  static bool isPhone(String str) {
    return new RegExp('^[1][3,4,5,6,7,8,9][0-9]{9}\$').hasMatch(str);
  }
}
