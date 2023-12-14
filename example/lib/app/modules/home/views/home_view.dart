import 'package:flutter/material.dart';

import 'package:example/app/routes/app_pages.dart';
import 'package:get/get.dart';

import 'package:flutter_muka/flutter_muka.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return PageInit(
      onExitBefore: () {
        logger.i('退出App');
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('HomeView'),
          centerTitle: true,
        ),
        body: ListView(
          children: [
            ListItem(
              color: Colors.white,
              title: Text('表单'),
              showArrow: true,
              onTap: () {
                Get.toNamed(Routes.FORM);
              },
              showDivider: true,
            ),
            ListItem(
              color: Colors.white,
              title: Text('线程测试'),
              showArrow: true,
              onTap: () {
                Get.toNamed(Routes.ISOLATE);
              },
            ),
            Container(
              height: 40,
              child: ITextField(
                controller: controller.textEditingController,
                hintText: '1111',
              ),
            )
          ],
        ),
      ),
    );
  }
}
