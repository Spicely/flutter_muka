part of flutter_muka;

class Utils {
  static String get platform {
    if (Platform.isAndroid) {
      return 'android';
    } else if (Platform.isIOS) {
      return 'ios';
    } else if (Platform.isMacOS) {
      return 'macOS';
    } else if (Platform.isFuchsia) {
      return 'fuchsia';
    } else if (Platform.isLinux) {
      return 'linux';
    } else {
      return 'windows';
    }
  }

  static Map<String, String> getUrlParams(String params) {
    List<String> value = params.split('&');
    Map<String, String> data = {};
    value.forEach((i) {
      List<String> v = i.split('=');
      data[v[0]] = v[1];
    });
    return data;
  }

  static String getSecrecyMobile(String mobile) {
    return mobile.replaceRange(3, 7, '****');
  }

  /// 判断是否为打包环境
  static bool get isProd {
    const product = bool.fromEnvironment('dart.vm.product');
    return product;
  }

  /// 打开扫码界面
  static Future<String?> openBarcode(
    BuildContext context, {
    bool? isAlbum,
    Color? scanLineColor,
    String? title,
  }) async {
    return await Navigator.push(
      context,
      CupertinoPageRoute<String>(
        builder: (BuildContext context) => ScanPage(
          isAlbum: isAlbum,
          scanLineColor: scanLineColor,
          title: title,
        ),
      ),
    );
  }
}
