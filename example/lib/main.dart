import 'package:flutter/material.dart';
import 'package:flutter_muka/flutter_muka.dart';

import 'package:get/get.dart';

import 'app/routes/app_pages.dart';

void main() {
  MukaConfig.config = MukaConfigTheme(
    futureLayoutBuilderTheme: MukaFutureLayoutBuilderTheme(
      errorWidget: (p0, p1, reload) => Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline),
            Text("Error"),
            TextButton(onPressed: reload, child: Text("Reload")),
          ],
        ),
      ),
    ),
  );
  final _navKey = GlobalKey<NavigatorState>();

  runApp(
    GetMaterialApp(
      navigatorKey: _navKey,
      title: "Application",
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      theme: ThemeData(
        useMaterial3: true,
        dividerTheme: DividerThemeData(
          color: Colors.grey.withOpacity(0.1),
        ),
      ),
      builder: (context, child) => ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Stack(
          children: [
            child ?? const SizedBox.expand(),
          ],
        ),
      ),
    ),
  );
}
