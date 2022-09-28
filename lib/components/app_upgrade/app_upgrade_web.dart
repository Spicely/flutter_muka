/*
 * Summary: APP更新检测 - web
 * Created Date: 2022-09-29 00:17:28
 * Author: Spicely
 * -----
 * Last Modified: 2022-09-29 00:27:08
 * Modified By: Spicely
 * -----
 * Copyright (c) 2022 Spicely Inc.
 * 
 * May the force be with you.
 * -----
 * HISTORY:
 * Date      	By	Comments
 */

import 'package:flutter/material.dart';

import '../../flutter_muka.dart';

class AppManage {
  static bool _open = false;

  static Future<void> upgrade(
    BuildContext context, {
    required String url,
    Image? updateImage,
    bool verify = false,
    String method = 'POST',
    Map<String, dynamic>? data,
    GestureTapCallback? onNotUpdate,
    GestureTapCallback? onUpdateBefore,
    GestureTapCallback? onUpdateAfter,
    ThemeData? themeData,
  }) async {
    logger.e('AppManage.upgrade -> 网页调用此函数无效');
    return;
  }
}
