import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/isolate_controller.dart';

class IsolateView extends GetView<IsolateController> {
  const IsolateView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('IsolateView'),
        centerTitle: true,
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: controller.createIsolate,
          child: Text('创建线程'),
        ),
      ),
    );
  }
}
