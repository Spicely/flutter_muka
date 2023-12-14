import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:flutter_muka/flutter_muka.dart';

import 'app/routes/app_pages.dart';

void main() {
  runApp(
    GetMaterialApp(
      title: "Application",
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      theme: ThemeData(
        useMaterial3: true,
        dividerTheme: DividerThemeData(
          color: Colors.grey.withOpacity(0.1),
        ),
      ),
    ),
  );
}
