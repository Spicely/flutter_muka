// ignore_for_file: non_constant_identifier_names

part of flutter_muka;

class IsolateTask {
  final Isolate isolate;

  final ReceivePort receivePort;

  final Stream? broadcastStream;

  IsolateTask(this.isolate, this.receivePort, this.broadcastStream);
}

class IsolateTaskData<T> {
  final SendPort sendPort;

  RootIsolateToken? rootIsolateToken;

  final T data;

  IsolateTaskData(this.sendPort, this.data, this.rootIsolateToken);
}

class Utils {
  /// 是否是桌面
  static bool isDesktop = (Platform.isMacOS || Platform.isWindows || Platform.isLinux) ? true : false;

  /// 是否是移动端
  static bool isMobile = (Platform.isAndroid || Platform.isIOS) ? true : false;

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

  /// 线程存储
  static final Map<String, IsolateTask> _isolateMap = {};

  /// 创建线程
  static Future<IsolateTask> createIsolate<T>(
    String name,
    T data,
    Function(IsolateTaskData<T>) callback, {
    bool isBroadcastStream = false,
  }) async {
    if (_isolateMap.containsKey(name)) {
      return _isolateMap[name]!;
    }
    RootIsolateToken? rootIsolateToken = RootIsolateToken.instance;
    ReceivePort receivePort = ReceivePort();
    Isolate isolate = await Isolate.spawn(callback, IsolateTaskData<T>(receivePort.sendPort, data, rootIsolateToken));

    isolate.addOnExitListener(receivePort.sendPort);

    Stream? broadcastStream;
    if (isBroadcastStream) {
      broadcastStream = receivePort.asBroadcastStream();
    }
    _isolateMap[name] = IsolateTask(isolate, receivePort, broadcastStream);
    return _isolateMap[name]!;
  }

  /// 获取线程
  static IsolateTask? getIsolate(String name) {
    return _isolateMap[name];
  }

  /// 销毁线程
  static void destroyIsolate(String name) {
    if (_isolateMap.containsKey(name)) {
      _isolateMap[name]!.receivePort.close();
      _isolateMap[name]!.isolate.kill(priority: Isolate.immediate);
      _isolateMap.remove(name);
    }
  }

  static String getSecrecyMobile(String mobile) {
    if (mobile.length < 11) return mobile;
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
  ///
  /// [unit] 单位
  static String formatNumber(int number, {String unit = '万'}) {
    if (number < 10000) {
      return number.toString();
    } else {
      return (number / 10000).toStringAsFixed(1) + unit;
    }
  }

  /// 异常捕获
  static Future<void> exceptionCapture(
    Function() cb, {
    void Function(DioException)? dioError,
    void Function(Object)? error,
  }) async {
    try {
      await cb();
    } on DioException catch (e) {
      dioError != null ? dioError.call(e) : MukaConfig.config.exceptionCapture.dioError(e);
    } catch (e) {
      error != null ? error.call(e) : MukaConfig.config.exceptionCapture.error(e);
    }
  }

  /// 压缩图片
  static Future<String?> compressImageQuality(String path, {String? filename, String? dir, int quality = 95}) async {
    if (dir == null) {
      Directory doc = await getApplicationDocumentsDirectory();
      dir = doc.path;
    }

    var targetPath = '$dir/${filename ?? DateTime.now().millisecondsSinceEpoch}.jpeg';
    return (await FlutterImageCompress.compressAndGetFile(path, targetPath, quality: quality))?.path;
  }

  /// 压缩内存图片
  static Future<Uint8List> compressImageMemory(Uint8List data, {String? filename, String? dir, int quality = 95}) async {
    return FlutterImageCompress.compressWithList(data, quality: quality);
  }

  /// 判断值是否为空
  ///
  /// 如果为空则返回默认值
  ///
  /// 如果不为空则返回属性值
  static T getValue<T>(T? obj, T defaultValue) {
    return obj == null
        ? defaultValue
        : obj is String
            ? obj.isEmpty
                ? defaultValue
                : obj
            : obj;
  }

  /// 时间戳转日期
  static String timestampToDate(
    int? timestamp, {
    String yesterday = '昨天',
    String beforeYesterday = '前天',
  }) {
    if (timestamp == null) return '';
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
    DateTime now = DateTime.now();
    if (dateTime.year == now.year) {
      if (dateTime.month == now.month && dateTime.day == now.day) {
        return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
      } else if (dateTime.month == now.month && dateTime.day == now.day - 1) {
        return yesterday;
      } else if (dateTime.month == now.month && dateTime.day == now.day - 2) {
        return beforeYesterday;
      } else {
        return '${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}';
      }
    } else {
      return '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}';
    }
  }

  /// 获取文件大小
  static String getFileSize(int size) {
    if (size < 1024) {
      return '$size B';
    } else if (size < 1024 * 1024) {
      return '${(size / 1024).toStringAsFixed(2)} KB';
    } else if (size < 1024 * 1024 * 1024) {
      return '${(size / 1024 / 1024).toStringAsFixed(2)} MB';
    } else {
      return '${(size / 1024 / 1024 / 1024).toStringAsFixed(2)} GB';
    }
  }

  /// 获取当月第一天
  static DateTime getFirstDayOfMonth(DateTime time) {
    return DateTime(time.year, time.month, 1);
  }

  /// 获取当月最后一天
  static DateTime getLastDayOfMonth(DateTime time) {
    return DateTime(time.year, time.month + 1, 0);
  }

  static Future<String> getImagePath(String url) async {
    Completer<String> completer = Completer();
    File file = await DefaultCacheManager().getSingleFile(url);
    completer.complete(file.path);
    return completer.future;
  }
}
