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

  ///

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

  /// 获取缓存大小
  static Future<String> getCacheSize() async {
    final tempDir = await getTemporaryDirectory();
    double size = await _getTotalSizeOfFilesInDir(tempDir);

    const List<String> unitArr = ['B', 'KB', 'MB', 'GB', 'TB'];
    int index = 0;
    while (size > 1024) {
      index++;
      size = size / 1024;
    }
    String v = size.toStringAsFixed(2);
    return v + unitArr[index];
  }

  /// 纯数字
  static final String DIGIT_REGEX = "[0-9]+";

  /// 含有数字
  static final String CONTAIN_DIGIT_REGEX = ".*[0-9].*";

  /// 纯字母
  static final String LETTER_REGEX = "[a-zA-Z]+";

  /// 包含字母
  static final String SMALL_CONTAIN_LETTER_REGEX = ".*[a-z].*";

  /// 包含字母
  static final String BIG_CONTAIN_LETTER_REGEX = ".*[A-Z].*";

  /// 包含字母
  static final String CONTAIN_LETTER_REGEX = ".*[a-zA-Z].*";

  /// 纯中文
  static final String CHINESE_REGEX = "[\u4e00-\u9fa5]";

  /// 仅仅包含字母和数字
  static final String LETTER_DIGIT_REGEX = "^[a-z0-9A-Z]+\$";
  static final String CHINESE_LETTER_REGEX = "([\u4e00-\u9fa5]+|[a-zA-Z]+)";
  static final String CHINESE_LETTER_DIGIT_REGEX = "^[a-z0-9A-Z\u4e00-\u9fa5]+\$";

  /// 纯数字
  static bool isOnly(String input) {
    if (input.isEmpty) return false;
    return new RegExp(DIGIT_REGEX).hasMatch(input);
  }

  /// 含有数字
  static bool hasDigit(String input) {
    if (input.isEmpty) return false;
    return new RegExp(CONTAIN_DIGIT_REGEX).hasMatch(input);
  }

  /// 是否包含中文
  static bool isChinese(String input) {
    if (input.isEmpty) return false;
    return new RegExp(CHINESE_REGEX).hasMatch(input);
  }

  /// 判断为null 或者空字符串
  static bool isEmpty(String? data) {
    return data == null || data.isEmpty;
  }

  /// 判断为null 或者空字符串
  static bool isNotEmpty(String? data) {
    return data != null && data.isNotEmpty;
  }

  /// 判断包含数字/字母
  static bool validCharacters(String str, {int min = 6, int max = 18}) {
    if (str.length < min || str.length > max) {
      return false;
    }
    final validCharacter = RegExp('^(?![0-9]+\$)(?![a-zA-Z]+\$)[0-9A-Za-z]');
    return validCharacter.hasMatch(str);
  }

  /// 验证手机号
  static bool isPhone(String str) {
    return new RegExp('^[1][3,4,5,6,7,8,9][0-9]{9}\$').hasMatch(str);
  }

  /// 数字超过10000转万
  static String formatNumber(int number) {
    if (number < 10000) {
      return number.toString();
    } else {
      return (number / 10000).toStringAsFixed(1) + '万';
    }
  }

  /// 压缩图片
  static Future<File?> compressImage(File file) async {
    var quality = 100;
    if (file.lengthSync() > 4 * 1024 * 1024) {
      quality = 50;
    } else if (file.lengthSync() > 2 * 1024 * 1024) {
      quality = 60;
    } else if (file.lengthSync() > 1 * 1024 * 1024) {
      quality = 70;
    } else if (file.lengthSync() > 0.5 * 1024 * 1024) {
      quality = 80;
    } else if (file.lengthSync() > 0.25 * 1024 * 1024) {
      quality = 90;
    }
    var dir = await getTemporaryDirectory();
    var targetPath = '${dir.absolute.path}/${DateTime.now().millisecondsSinceEpoch}.jpg';
    File? result = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      targetPath,
      quality: quality,
    );
    return result;
  }

  /// 压缩图片
  static Future<Uint8List?> compressWithList(
    Uint8List image, {
    int minWidth = 1920,
    int minHeight = 1080,
    int quality = 95,
    int rotate = 0,
    int inSampleSize = 1,
    bool autoCorrectionAngle = true,
    CompressFormat format = CompressFormat.jpeg,
    bool keepExif = false,
  }) async {
    Uint8List? result = await FlutterImageCompress.compressWithList(
      image,
      quality: quality,
      minWidth: minWidth,
      minHeight: minHeight,
      rotate: rotate,
      inSampleSize: inSampleSize,
      autoCorrectionAngle: autoCorrectionAngle,
      format: format,
      keepExif: keepExif,
    );
    return result;
  }

  static double randomDouble(double min, double max) {
    var x = Random().nextDouble() * max + min;
    return x;
  }

  /// 异常捕获
  static Future<void> exceptionCapture(
    Function() cb, {
    void Function(DioError)? dioError,
    void Function(Object)? error,
  }) async {
    try {
      await cb();
    } on DioError catch (e) {
      dioError != null ? dioError.call(e) : MukaConfig.config.exceptionCapture.dioError(e);
    } catch (e) {
      error != null ? error.call(e) : MukaConfig.config.exceptionCapture.error(e);
    }
  }
}
