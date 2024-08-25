import 'package:get/get.dart';

import '../modules/form/bindings/form_binding.dart';
import '../modules/form/views/form_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/isolate/bindings/isolate_binding.dart';
import '../modules/isolate/views/isolate_view.dart';
import '../modules/photoManager/bindings/photo_manager_binding.dart';
import '../modules/photoManager/views/photo_manager_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.HOME;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.FORM,
      page: () => const FormView(),
      binding: FormBinding(),
    ),
    GetPage(
      name: _Paths.ISOLATE,
      page: () => const IsolateView(),
      binding: IsolateBinding(),
    ),
    GetPage(
      name: _Paths.PHOTO_MANAGER,
      page: () => const PhotoManagerView(),
      binding: PhotoManagerBinding(),
    ),
  ];
}
