// ignore_for_file: non_constant_identifier_names

part of flutter_muka;

typedef List<Interceptor> HttpUtilsInterceptors(Dio? dio);

enum HttpUtilsMethod {
  GET,
  POST,
  PUT,
  PATCH,
  DELETE,
}

class HttpUtils {
  /// global dio object
  static Dio? _dio;

  /// 请求地址
  static set baseUrl(String v) => _dio == null ? _options.baseUrl = v : _dio?.options.baseUrl = v;

  static String get baseUrl => _dio == null ? _options.baseUrl : _dio!.options.baseUrl;

  /// 超时时间
  static Duration CONNECT_TIMEOUT = Duration(seconds: 10);

  static Duration RECEIVE_TIMEOUT = Duration(seconds: 10);

  /// 输出请求内容
  static bool debug = false;

  /// 代理设置 代理地址
  static String? PROXY_URL;

  /// 添加额外功能
  static HttpUtilsInterceptors? interceptors;

  /// 是否携带cookie
  static bool? withCredentials = false;

  static BaseOptions _options = BaseOptions(
    connectTimeout: CONNECT_TIMEOUT,
    receiveTimeout: RECEIVE_TIMEOUT,
  );

  /// request method
  static Future<dynamic> request(
    String url, {
    dynamic data,
    HttpUtilsMethod method = HttpUtilsMethod.POST,
    Map<String, dynamic>? headers,
    String? contentType,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
    ProgressCallback? onSendProgress,
  }) async {
    data = data ?? (method == HttpUtilsMethod.GET ? null : {});
    headers = headers ?? {};
    contentType = contentType ?? Headers.jsonContentType;

    Dio? dio = await createInstance();
    var result;

    Response response;
    response = await dio!.request(
      url,
      queryParameters: method == HttpUtilsMethod.GET ? data : null,
      data: method != HttpUtilsMethod.GET ? data : null,
      cancelToken: cancelToken,
      onReceiveProgress: onReceiveProgress,
      onSendProgress: onSendProgress,
      options: Options(
        method: _getMethod(method),
        headers: headers,
        contentType: contentType,
      ),
    );

    result = response.data;
    return result;
  }

  static String _getMethod(HttpUtilsMethod method) {
    switch (method.index) {
      case 1:
        return 'POST';
      case 2:
        return 'PUT';
      case 3:
        return 'PATCH';
      case 4:
        return 'DELETE';
      default:
        return 'GET';
    }
  }

  /// 创建 dio 实例对象
  static Future<Dio?> createInstance() async {
    if (_dio == null) {
      _dio = Dio(_options);

      if (!kIsWeb) {
        _dio!.httpClientAdapter = IOHttpClientAdapter()
          ..onHttpClientCreate = (client) {
            client.badCertificateCallback = (cert, host, port) {
              return true;
            };
            return null;
          };
      }

      interceptors?.call(_dio).forEach((i) {
        _dio!.interceptors.add(i);
      });

      if (kIsWeb) {
        // var adapter = BrowserHttpClientAdapter();
        // adapter.withCredentials = withCredentials!;
        // _dio!.httpClientAdapter = adapter;
      } else {
        var appDocDir = await getApplicationDocumentsDirectory();
        String appDocPath = appDocDir.path;
        PersistCookieJar cookieJar = PersistCookieJar(storage: FileStorage(appDocPath + '/.cookies/'));
        _dio!.interceptors.add(CookieManager(cookieJar));
      }

      /// 设置代理
      if (PROXY_URL != null) {
        _dio!.httpClientAdapter = IOHttpClientAdapter()
          ..onHttpClientCreate = (client) {
            client.findProxy = (uri) {
              return "PROXY $PROXY_URL";
            };
            client.badCertificateCallback = (cert, host, port) => true;
            return null;
          };
      }
      if (debug) {
        _dio!.interceptors.add(_MukaLogInterceptor());
      }
    }

    return _dio;
  }
}

class _MukaLogInterceptor extends Interceptor {
  String _request = '';

  void _printKV(String key, Object? v) {
    _request += '$key: $v\n';
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    _request = '';
    _printKV('uri', options.uri);
    _printKV('method', options.method);
    _printKV('responseType', options.responseType.toString());
    _printKV('followRedirects', options.followRedirects);
    _printKV('connectTimeout', options.connectTimeout);
    _printKV('sendTimeout', options.sendTimeout);
    _printKV('receiveTimeout', options.receiveTimeout);
    _printKV('receiveDataWhenStatusError', options.receiveDataWhenStatusError);
    _printKV('extra', options.extra);
    _printKV('data', options.data);
    _printKV('queryParameters', options.queryParameters);
    logger.d(_request);

    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) async {
    logger.d(response.data);
    handler.next(response);
  }
}
