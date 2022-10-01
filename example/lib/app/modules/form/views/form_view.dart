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
                props: MFormItemTextFieldProps(placeholder: '测试内容'),
              ),
              MFormItem(
                title: '性别',
                field: 'sex',
                type: MFormItemType.radio,
                initValue: 1,
                props: MFormItemSelectProps(
                  items: [
                    MFormItemSelectItem(label: '男', value: 1),
                    MFormItemSelectItem(label: '女', value: 2),
                  ],
                ),
              ),
              MFormItem(
                title: 'select',
                field: 'sex1',
                type: MFormItemType.select,
                initValue: 1,
                props: MFormItemSelectProps(
                  placeholder: '请选择性别',
                  items: [
                    MFormItemSelectItem(label: '男', value: 1),
                    MFormItemSelectItem(label: '女', value: 2),
                  ],
                ),
              ),
              MFormItem(
                title: '时间选择',
                field: 'time',
                type: MFormItemType.time,
                props: MFormItemTimeProps(
                  placeholder: '请选择时间',
                  firstDate: DateTime.parse('2010-08-01'),
                  lastDate: DateTime.parse('2023-08-01'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
