library flutter_muka;

import 'dart:async';
import 'dart:ui' as ui;
import 'dart:math';
import 'package:dio/adapter.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:group_button/group_button.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';
import 'package:scan/scan.dart';
import 'src/adapter_browser.dart' if (dart.library.js) 'package:dio/adapter_browser.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:flutter/services.dart';
import 'package:package_info/package_info.dart';
import 'package:signature/signature.dart';
import 'model/dialog_share_data/index.dart';
import 'src/utils/utils.dart' if (dart.library.js) 'src/utils/utils_web.dart';

export 'package:dio/dio.dart';
export 'package:intl/intl.dart';
export 'package:path_provider/path_provider.dart';
export 'package:flutter_spinkit/flutter_spinkit.dart';
export 'package:extended_image/extended_image.dart' show ExtendedImage;
export 'package:extended_image/src/utils.dart';
export 'package:cached_network_image/cached_network_image.dart';
export 'package:shimmer/shimmer.dart';
export 'package:flutter_html/flutter_html.dart';
export 'package:http_parser/http_parser.dart';

export 'components/app_upgrade/app_upgrade.dart' if (dart.library.js) 'components/app_upgrade/app_upgrade_web.dart';
export 'components/cached_image/cached_image.dart' if (dart.library.js) 'components/cached_image/cached_image_web.dart';
export 'components/multi_image/multi_image.dart' if (dart.library.js) 'components/multi_image/multi_image_web.dart';
export 'src/utils/utils.dart' if (dart.library.js) 'src/utils/utils_web.dart';
export 'views/crop_image/crop_image.dart' if (dart.library.js) 'views/crop_image/crop_image_web.dart';

part 'src/http_utils.dart';
part 'src/dialog_utils.dart';
part 'src/widget_to_image.dart';
part 'src/extend_class.dart';
part 'src/muka_config_theme.dart';
part 'components/auto_keep.dart';
part 'components/bottom_sheet_layout.dart';
part 'components/current_version.dart';
part 'components/m_checkbox.dart';
part 'components/list_item.dart';

part 'components/text_field.dart';
part 'components/code_time.dart';
part 'components/empty.dart';
part 'components/future_layout_builder.dart';
part 'components/page_init.dart';
part 'components/grid_box.dart';
part 'components/grid_item.dart';
part 'components/start_up.dart';
part 'components/signature_view.dart';
part 'components/divider_text.dart';
part 'components/price_number.dart';
part 'components/easy_popup.dart';
part 'components/virtual_keyboard.dart';
part 'components/progress_loading_button.dart';
part 'components/dashboard_progress.dart';
part 'views/scan_page.dart';
part 'components/m_form.dart';

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
