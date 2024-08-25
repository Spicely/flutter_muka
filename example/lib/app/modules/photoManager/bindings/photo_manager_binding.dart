import 'package:get/get.dart';

import '../controllers/photo_manager_controller.dart';

class PhotoManagerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PhotoManagerController>(
      () => PhotoManagerController(),
    );
  }
}
