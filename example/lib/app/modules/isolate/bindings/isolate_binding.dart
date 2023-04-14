import 'package:get/get.dart';

import '../controllers/isolate_controller.dart';

class IsolateBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<IsolateController>(
      () => IsolateController(),
    );
  }
}
