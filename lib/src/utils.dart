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

  /// 判断是否为线上环境
  static bool get isProd {
    return kReleaseMode;
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

  static Future<String?> showDateTimePicker(
    BuildContext context, {
    required DateTime initialDate,
    required DateTime firstDate,
    required DateTime lastDate,
    required TimeOfDay initialTime,
  }) async {
    DateTime? ymd = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
    );
    if (ymd == null) return null;

    TimeOfDay? hm = await showTimePicker(context: context, initialTime: initialTime);
    if (hm == null) return null;

    DateTime now = DateTime.now();
    String _hm = DateFormat('HH:mm:ss').format(DateTime(now.year, now.month, now.day, hm.hour, hm.minute));
    return DateFormat('yyyy-MM-dd ').format(ymd) + _hm;
  }

  static Future<double> _getTotalSizeOfFilesInDir(FileSystemEntity file) async {
    if (file is File && file.existsSync()) {
      int length = await file.length();
      return double.parse(length.toString());
    }
    if (file is Directory && file.existsSync()) {
      List children = file.listSync();
      double total = 0;
      if (children.isNotEmpty) {
        for (final FileSystemEntity child in children) {
          total += await _getTotalSizeOfFilesInDir(child);
        }
      }

      return total;
    }
    return 0;
  }

  static Future<String> getCacheSize() async {
    final tempDir = await getTemporaryDirectory();
    double size = await _getTotalSizeOfFilesInDir(tempDir);

    const List<String> unitArr = ['B', 'K', 'M', 'G', 'T'];
    int index = 0;
    while (size > 1024) {
      index++;
      size = size / 1024;
    }
    String v = size.toStringAsFixed(2);
    return v + unitArr[index];
  }
}
