import 'package:flutter/material.dart';
import 'package:flutter_muka/flutter_muka.dart';

import 'package:get/get.dart';

import '../controllers/form_controller.dart';

class FormView extends GetView<FormController> {
  const FormView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FormView'),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          MForm(
            children: [
              MFormItem(
                title: '测试',
                field: 'name',
                textFieldProps: MFormItemTextFieldProps(hintText: '测试内容'),
              ),
              MFormItem(
                title: '性别',
                field: 'sex',
                type: MFormItemType.radio,
                initValue: 1,
                radioProps: MFormRadioProps(
                  buttons: [
                    MFormItemRadio(label: '男', value: 1),
                    MFormItemRadio(label: '女', value: 2),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
