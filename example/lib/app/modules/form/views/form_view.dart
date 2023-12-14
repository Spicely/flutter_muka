import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:flutter_muka/flutter_muka.dart';

import '../controllers/form_controller.dart';

class FormView extends GetView<FormController> {
  const FormView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return PageInit(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('FormView'),
          centerTitle: true,
        ),
        body: ListView(
          children: [],
        ),
      ),
    );
  }
}
