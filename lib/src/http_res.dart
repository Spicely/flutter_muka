import 'package:flutter/material.dart';
import 'package:muka/model/Response/index.dart';

class HttpRes {
  static Future<dynamic> verify(BuildContext context, dynamic data) {
    try {
      HttpResponse res = HttpResponse.fromJson(data);
      switch (res.code) {
        case 200:
          return Future.value(res.data);
        default:
          return Future.error('暂无更新');
      }
    } catch (e) {
      return Future.error(e);
    }
  }
}
