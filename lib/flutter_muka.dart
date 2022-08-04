library flutter_muka;

import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/adapter.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_muka/views/crop_editor_helper.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:r_upgrade/r_upgrade.dart';
import 'package:scan/scan.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'src/adapter_browser.dart' if (dart.library.js) 'package:dio/adapter_browser.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_muka/src/http_res.dart';
import 'package:package_info/package_info.dart';
import 'package:signature/signature.dart';
import 'model/upgrade_model/index.dart';
import 'model/dialog_share_data/index.dart';

export 'package:dio/dio.dart';
export 'package:intl/intl.dart';
export 'package:path_provider/path_provider.dart';
export 'package:flutter_spinkit/flutter_spinkit.dart';
export 'package:extended_image/extended_image.dart' show ExtendedImage;
export 'package:extended_image/src/utils.dart';
export 'package:cached_network_image/cached_network_image.dart';
export 'package:shimmer/shimmer.dart';

part 'src/http_utils.dart';
part 'src/dialog_utils.dart';
part 'src/app_update.dart';
part 'src/utils.dart';
part 'src/verify_utils.dart';
part 'src/extend_class.dart';
part 'src/muka_config_theme.dart';
part 'components/list_item.dart';
part 'components/multi_image.dart';
part 'components/text_field.dart';
part 'components/code_time.dart';
part 'components/empty.dart';
part 'components/page_init.dart';
part 'components/grid_box.dart';
part 'components/grid_item.dart';
part 'components/start_up.dart';
part 'components/signature_view.dart';
part 'components/divider_text.dart';
part 'components/price_number.dart';
part 'components/change_number.dart';
part 'components/easy_popup.dart';
part 'components/virtual_keyboard.dart';
part 'components/progress_loading_button.dart';
part 'components/dashboard_progress.dart';
part 'components/app_upgrade.dart';
part 'components/cached_image.dart';
part 'views/crop_image.dart';
part 'views/scan_page.dart';

Logger logger = Logger(
  printer: PrettyPrinter(
    methodCount: 2, // number of method calls to be displayed
    errorMethodCount: 8, // number of method calls if stacktrace is provided
    lineLength: 120, // width of the output
    colors: true, // Colorful log messages
    printEmojis: true, // Print an emoji for each log message
    printTime: false, // Should each log print contain a timestamp
  ),
);
