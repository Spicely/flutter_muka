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

  /// 忽略证书检测
  static bool ignoreCertificate = true;

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
        _dio!.httpClientAdapter = IOHttpClientAdapter(
          createHttpClient: () {
            HttpClient client = new HttpClient()..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
            client.findProxy = (uri) {
              return "PROXY $PROXY_URL";
            };
            return client;
          },
        );
      }

      /// 忽略证书
      // if (ignoreCertificate) {
      //   _dio!.httpClientAdapter = IOHttpClientAdapter(
      //     createHttpClient: () {
      //       HttpClient client = new HttpClient()..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
      //       return client;
      //     },
      //   );
      // }
      if (debug) {
        _dio!.interceptors.add(
          PrettyDioLogger(
            requestHeader: true,
            requestBody: true,
            responseBody: true,
            responseHeader: false,
            error: true,
            compact: true,
            maxWidth: 90,
          ),
        );
      }
    }

    return _dio;
  }
}
