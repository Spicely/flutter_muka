import 'package:flutter/material.dart';
import 'package:flutter_muka/flutter_muka.dart';

import 'package:get/get.dart';

import '../controllers/photo_manager_controller.dart';

class PhotoManagerView extends GetView<PhotoManagerController> {
  const PhotoManagerView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PhotoManagerView'),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          ListView(
            children: [Text('1111')],
          ),
          const DraggableScrollableSheetManager(),
        ],
      ),
    );
  }
}
