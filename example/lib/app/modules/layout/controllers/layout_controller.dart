import 'package:flutter/services.dart';
import 'package:get/get.dart';

class LayoutController extends GetxController {
  List<int> data = RxList([]);

  Future<void> getData() async {
    await Future.delayed(Duration(seconds: 2));
    // data.addAll([1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20]);
    throw MissingPluginException('asdsada');
  }
}
