import 'package:flutter_muka/flutter_muka.dart';
import 'package:get/get.dart';

class IsolateController extends GetxController {
  late IsolateTask isolateTask;

  void createIsolate() async {
    logger.i('创建线程');
    isolateTask = await Utils.createIsolate<int>('10010', 1, name);
    isolateTask.receivePort.listen((message) {
      print(message);
    });
    // isolate.
  }

  @override
  void onClose() {
    Utils.destroyIsolate('10010');

    super.onClose();
  }

  /// 线程计算
  static void name(IsolateTaskData<int> task) {
    print(task.data);
    int i = 0;
    while (i < 10000000000) {
      i++;
    }
    logger.i('线程计算完成');
  }
}
