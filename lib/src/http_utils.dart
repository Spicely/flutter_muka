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
  // ignore: non_constant_identifier_names
  static String BASE_URL = '';

  /// 超时时间
  // ignore: non_constant_identifier_names
  static int CONNECT_TIMEOUT = 40000;
  // ignore: non_constant_identifier_names
  static int RECEIVE_TIMEOUT = 40000;

  /// 输出请求内容
  // ignore: non_constant_identifier_names
  static bool DEBUG = false;

  /// 代理设置 代理地址
  // ignore: non_constant_identifier_names
  static String? PROXY_URL;

  /// 添加额外功能
  static HttpUtilsInterceptors? interceptors;

  /// 是否携带cookie
  static bool? withCredentials = false;

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
      BaseOptions options = BaseOptions(
        baseUrl: BASE_URL,
        connectTimeout: CONNECT_TIMEOUT,
        receiveTimeout: RECEIVE_TIMEOUT,
      );

      _dio = Dio(options);

      (_dio!.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate = (client) {
        client.badCertificateCallback = (cert, host, port) {
          return true;
        };
        return null;
      };

      interceptors?.call(_dio).forEach((i) {
        _dio!.interceptors.add(i);
      });

      if (kIsWeb) {
        var adapter = BrowserHttpClientAdapter();
        adapter.withCredentials = withCredentials!;
        _dio!.httpClientAdapter = adapter;
      } else {
        var appDocDir = await getApplicationDocumentsDirectory();
        String appDocPath = appDocDir.path;
        PersistCookieJar cookieJar = PersistCookieJar(storage: FileStorage(appDocPath + '/.cookies/'));
        _dio!.interceptors.add(CookieManager(cookieJar));
      }

      /// 设置代理
      if (PROXY_URL != null) {
        (_dio!.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate = (HttpClient client) {
          client.findProxy = (uri) {
            return "PROXY $PROXY_URL";
          };
          client.badCertificateCallback = (X509Certificate cert, String host, int port) => true;
          return null;
        };
      }
      if (DEBUG) {
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
