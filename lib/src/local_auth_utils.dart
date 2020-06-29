part of muka;

/////////////////////////////////////////////////////////////////////////
//// All rights reserved.
//// author: Spicely
//// Summary: 指纹验证封装
//// Date: 2020年06月29日 21:52:52 Monday
//////////////////////////////////////////////////////////////////////////

class LocalAuthUtils {
  static LocalAuthentication _auth = LocalAuthentication();

  /// 是否有本地身份验证
  static Future<bool> _canCheckBiometrics() async {
    return await _auth.canCheckBiometrics;
  }

  /// 唤起指纹验证
  static Future<bool> authenticateWithBiometrics() async {
    if (await _canCheckBiometrics()) {
      return await _auth.authenticateWithBiometrics(localizedReason: 'Please authenticate to show account balance');
    } else {
      return false;
    }
  }
}
