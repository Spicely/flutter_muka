import 'package:example/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:flutter_muka/flutter_muka.dart';

import 'package:get/get.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          ),
        ],
      ),
    );
  }
}
