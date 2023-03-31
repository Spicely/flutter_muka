library flutter_muka;

import 'dart:async';
import 'dart:io';
import 'package:dio/io.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:logger/logger.dart';
import 'flutter_muka.dart';
import 'package:flutter/material.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:flutter/services.dart';

export 'package:dio/dio.dart';
export 'package:path_provider/path_provider.dart';
export 'package:flutter_spinkit/flutter_spinkit.dart';
export 'package:extended_image/extended_image.dart' show ExtendedImage;
export 'package:extended_image/src/utils.dart';
export 'package:cached_network_image/cached_network_image.dart';
export 'package:shimmer/shimmer.dart';
export 'package:http_parser/http_parser.dart';

part 'src/utils.dart';
part 'src/muka_config_theme.dart';
part 'src/http_utils.dart';

part 'components/auto_keep.dart';
part 'components/bottom_sheet_layout.dart';
part 'components/list_item.dart';
part 'components/text_field.dart';
part 'components/code_time.dart';
part 'components/empty.dart';
part 'components/cached_image.dart';
part 'components/future_layout_builder.dart';
part 'components/grid_box.dart';
part 'components/grid_item.dart';
part 'components/virtual_keyboard.dart';
part 'components/multi_image.dart';
part 'components/diver_text.dart';
part 'components/notice_dialog.dart';

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
