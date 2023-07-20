library flutter_muka;

import 'dart:async';
import 'dart:io';
import 'dart:isolate';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:back_to_desktop/back_to_desktop.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/io.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:logger/logger.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import 'flutter_muka.dart';

export 'package:extended_image/extended_image.dart';
export 'package:dio/dio.dart' hide MultipartFile;
export 'package:flutter_spinkit/flutter_spinkit.dart';
export 'package:http_parser/http_parser.dart';
export 'package:path_provider/path_provider.dart';
export 'package:shimmer/shimmer.dart';

part 'components/auto_keep.dart';
part 'components/bottom_sheet_layout.dart';
part 'components/cached_image.dart';
part 'components/code_time.dart';
part 'components/diver_text.dart';
part 'components/empty.dart';
part 'components/future_layout_builder.dart';
part 'components/grid_box.dart';
part 'components/grid_item.dart';
part 'components/list_item.dart';
part 'components/multi_image.dart';
part 'components/notice_dialog.dart';
part 'components/page_init.dart';
part 'components/text_field.dart';
part 'components/virtual_keyboard.dart';
part 'src/http_utils.dart';
part 'src/muka_config_theme.dart';
part 'src/utils.dart';

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
