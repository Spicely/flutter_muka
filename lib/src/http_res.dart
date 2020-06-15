import 'package:flutter/material.dart';
import 'package:muka/model/Response/index.dart';

class HttpRes {
  static verify(BuildContext context, dynamic data, {void Function(dynamic data) callback}) {
    try {
      HttpResponse res = HttpResponse.fromJson(data);
      switch (res.status) {
        case 200:
          callback?.call(res.data);
          break;
      }
    } catch (e) {
      print(e);
    }
  }
}