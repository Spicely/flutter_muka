part of flutter_muka;

abstract class BasicRoute {
  BasicRoute() {
    initRoute();
  }

  static FluroRouter router = FluroRouter();

  static bool debug = false;

  static TransitionType transitionType = TransitionType.native;

  initRoute() {}

  /// 对参数进行encode，解决参数中有特殊字符，影响fluro路由匹配
  static Future navigateTo(
    BuildContext context,
    String path, {
    Map<String, dynamic>? params,
    TransitionType? transition,
    RouteSettings? routeSettings,
    bool replace = false,
    bool rootNavigator = false,
    bool clearStack = false,
  }) {
    String query = '';
    if (params != null) {
      int index = 0;
      for (var key in params.keys) {
        var value = Uri.encodeComponent(params[key].toString());
        if (index == 0) {
          query = "?";
        } else {
          query = query + "\&";
        }
        query += "$key=$value";
        index++;
      }
    }
    if (debug) {
      LogUtil.v('navigateTo传递的参数：${query.isEmpty ? routeSettings?.arguments : query}');
    }

    path = path + query;
    return router.navigateTo(
      context,
      path,
      transition: transition ?? transitionType,
      routeSettings: routeSettings,
      replace: replace,
      rootNavigator: rootNavigator,
      clearStack: clearStack,
    );
  }

  static void pop<T>(BuildContext context, [T? result]) => router.pop(context, result);
}
