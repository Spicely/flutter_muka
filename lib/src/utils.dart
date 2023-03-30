// ignore_for_file: non_constant_identifier_names

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
  static bool isEmpty(dynamic data) {
    switch (data.runtimeType) {
      case int:
        return data == 0;
      case String:
        return (data as String).isEmpty;
      default:
        return true;
    }
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

  /// 压缩图片
  static Future<File?> compressImage(File file, {String? filename}) async {
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
    File? result = await compressImageQuality(file, quality, filename: filename);
    return result;
  }

  /// 压缩图片
  static Future<File?> compressImageQuality(File file, int quality, {String? filename}) async {
    Directory dir = await getApplicationDocumentsDirectory();

    /// 获取文件名后缀
    var suffix = file.path.substring(file.path.lastIndexOf('.'));
    CompressFormat format;

    /// 依据后缀判断图片格式
    switch (suffix) {
      case '.png':
        format = CompressFormat.png;
        break;
      case '.heic':
        format = CompressFormat.heic;
        break;
      case '.webp':
        format = CompressFormat.webp;
        break;
      default:
        format = CompressFormat.jpeg;
    }

    var targetPath = '${dir.path}/${filename ?? DateTime.now().millisecondsSinceEpoch}$suffix';
    File? result = await FlutterImageCompress.compressAndGetFile(
      file.path,
      targetPath,
      format: format,
      quality: quality,
    );
    return result;
  }
}
