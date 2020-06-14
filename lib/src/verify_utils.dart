part of '../muka.dart';

class VerifyUtils {
  static bool isPhone(String str) {
    return new RegExp('^[1][3,4,5,6,7,8,9][0-9]{9}\$').hasMatch(str);
  }
}

class HttpRes {
  static verify(BuildContext context, dynamic data, {void Function(dynamic data) callback}) {
    try {
      HttpResponse res = HttpResponse.fromJson(data);
      switch (res.status) {
        case 200:
          callback?.call(res.data);
          break;
        case 201:
          ToastUtils.error(context, res.msg);
          break;
      }
    } catch (e) {
      print(e);
    }
  }
}
