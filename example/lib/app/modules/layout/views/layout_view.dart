import 'package:flutter/material.dart';
import 'package:flutter_muka/flutter_muka.dart';

import 'package:get/get.dart';

import '../controllers/layout_controller.dart';

class LayoutView extends GetView<LayoutController> {
  const LayoutView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('LayoutView'),
        centerTitle: true,
      ),
      body: FutureLayoutBuilder(
        future: controller.getData,
        builder: (_) => Obx(
          () => ListView.builder(
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                title: Text('Item $index'),
              );
            },
            itemCount: controller.data.length,
          ),
        ),
      ),
    );
  }
}
