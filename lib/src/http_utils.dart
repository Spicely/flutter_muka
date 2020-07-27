part of muka;

class HttpUtils {
  /// global dio object
  static Dio dio;

  /// default options
  static String BASE_URL = '';
  static int CONNECT_TIMEOUT = 40000;
  static int RECEIVE_TIMEOUT = 40000;
  static bool DEBUG = false;

  /// http request methods
  static const String GET = 'GET';
  static const String POST = 'POST';
  static const String PUT = 'PUT';
  static const String PATCH = 'PATCH';
  static const String DELETE = 'DELETE';

  /// request method
  static Future<Map> request(
    String url, {
    dynamic data,
    String method = 'POST',
    Map<String, dynamic> headers,
    String contentType,
  }) async {
    data = data ?? (method.toUpperCase() == 'GET' ? null : {});
    headers = headers ?? {};
    contentType = contentType ?? Headers.jsonContentType;

    /// restful 请求处理
    /// /gysw/search/hist/:user_id        user_id=27
    /// 最终生成 url 为     /gysw/search/hist/27
    try {
      data.forEach((key, value) {
        if (url.indexOf(key) != -1) {
          url = url.replaceAll(':$key', value.toString());
        }
      });
    } catch (e) {
      print(e);
    }

    // /// 打印请求相关信息：请求地址、请求方式、请求参数
    if (DEBUG) {
      print('请求地址：【' + method + '  ' + url + '】');
      print('请求参数：【' + data.toString() + '】');
    }

    Dio dio = await createInstance();
    var result;

    // try {} on DioError catch (e) {
    //   /// 打印请求失败相关信息
    //   print('请求出错：' + e.toString());
    // }
    Response response;
    response = await dio.request(
      url,
      queryParameters: method.toUpperCase() == 'GET' ? data : null,
      data: method.toUpperCase() != 'GET' ? data : null,
      options: Options(
        method: method,
        headers: headers,
        contentType: contentType,
      ),
    );

    result = response.data;

    /// 打印响应相关信息
    if (DEBUG) {
      print('响应数据：【' + response.toString() + '】');
    }
    return result;
  }

  /// 创建 dio 实例对象
  static Future<Dio> createInstance() async {
    if (dio == null) {
      BaseOptions options = BaseOptions(
        baseUrl: BASE_URL,
        connectTimeout: CONNECT_TIMEOUT,
        receiveTimeout: RECEIVE_TIMEOUT,
      );

      dio = Dio(options);
      var appDocDir = await getApplicationDocumentsDirectory();
      String appDocPath = appDocDir.path;
      PersistCookieJar cookieJar = PersistCookieJar(dir: appDocPath + '/.cookies/');
      dio.interceptors.add(CookieManager(cookieJar));

      /// 设置代理
      if (PROXY_URL != null) {
        (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate = (HttpClient client) {
          client.findProxy = (uri) {
            return "PROXY $uri";
          };
        };
      }
    }

    return dio;
  }

  /// 清空 dio 对象
  static clear() {
    dio = null;
  }

  /// 代理设置 代理地址
  static String PROXY_URL;
}
