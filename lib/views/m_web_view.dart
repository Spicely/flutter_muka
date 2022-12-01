/*
 * Summary: WebView
 * Created Date: 2022-12-01 16:58:17
 * Author: Spicely
 * -----
 * Last Modified: 2022-12-01 17:11:36
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
import 'package:webview_flutter/webview_flutter.dart';

class MWebView extends StatelessWidget {
  final String? title;

  final String url;

  const MWebView({
    Key? key,
    this.title,
    required this.url,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title ?? ''),
      ),
      body: WebView(
        initialUrl: url,
        javascriptMode: JavascriptMode.unrestricted,
      ),
    );
  }
}
