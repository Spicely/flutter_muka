part of flutter_muka;
/*
 * Summary: flutter_muka 全局配置
 * Created Date: 2022-08-03 11:10:06
 * Author: Spicely
 * -----
 * Last Modified: 2023-06-02 15:15:09
 * Modified By: Spicely
 * -----
 * Copyright (c) 2022 Spicely Inc.
 * 
 * May the force be with you.
 * -----
 * HISTORY:
 * Date      	By	Comments
 */

class MukaBottomSheetLayoutTheme {
  /// layout 背景颜色
  final Color bgColor;

  final EdgeInsets padding;

  /// layout 圆角
  final BorderRadiusGeometry? borderRadius;

  final Gradient? gradient;

  final DecorationImage? image;

  final double barHeight;

  final double barWidth;

  /// 拖拽栏颜色
  final Color barColor;

  final BorderRadiusGeometry? barBorderRadius;

  final EdgeInsetsGeometry barPadding;

  const MukaBottomSheetLayoutTheme({
    this.bgColor = Colors.white,
    this.padding = const EdgeInsets.symmetric(horizontal: 17),
    this.borderRadius,
    this.gradient,
    this.image,
    this.barHeight = 4,
    this.barWidth = 40,
    this.barColor = Colors.grey,
    this.barBorderRadius,
    this.barPadding = const EdgeInsets.symmetric(vertical: 10),
  });
}

class MukaFutureLayoutBuilderTheme {
  final Widget Function(BuildContext) loadingWidget;

  final Widget Function(BuildContext, dynamic, Function() reload) errorWidget;

  const MukaFutureLayoutBuilderTheme({
    this.loadingWidget = _loadingWidget,
    this.errorWidget = _errorWidget,
  });
}

Widget _errorWidget(BuildContext context, error, reload) {
  return Center(
    child: Text(error is DioException ? error.message ?? '' : error.toString()),
  );
}

Widget _loadingWidget(BuildContext context) {
  return Center(
    child: SpinKitFadingCube(
      color: Theme.of(context).primaryColor,
    ),
  );
}

Widget _emptyWidget(BuildContext context) => SizedBox(child: Text('暂无数据'));

class MukaConfigTheme {
  /// 图片补充地址 [https://www.baidu.com]
  final String baseUrl;

  final Widget Function(BuildContext) emptyWidget;

  /// BottomSheetLayout
  final MukaBottomSheetLayoutTheme bottomSheetLayoutTheme;

  /// FutureLayoutBuilder 参数
  final MukaFutureLayoutBuilderTheme futureLayoutBuilderTheme;

  final MukaExceptionCapture exceptionCapture;

  final MukaCachedTheme cachedTheme;

  MukaConfigTheme({
    this.baseUrl = '',
    this.emptyWidget = _emptyWidget,
    this.bottomSheetLayoutTheme = const MukaBottomSheetLayoutTheme(),
    this.futureLayoutBuilderTheme = const MukaFutureLayoutBuilderTheme(),
    this.exceptionCapture = const MukaExceptionCapture(),
    this.cachedTheme = const MukaCachedTheme(),
  });
}

Widget _errorBuilder(BuildContext context, {double? width, double? height}) => const Icon(Icons.error);

Widget _cachePlaceholder({double? width, double? height}) => Shimmer.fromColors(
      baseColor: Colors.grey.shade200,
      highlightColor: Colors.grey.shade100,
      child: Container(width: width, height: height, color: Colors.grey),
    );

class MukaCachedTheme {
  final Widget Function(BuildContext, {double? width, double? height}) errorBuilder;

  /// 占位图
  final Widget Function({double? width, double? height}) placeholder;

  const MukaCachedTheme({
    this.errorBuilder = _errorBuilder,
    this.placeholder = _cachePlaceholder,
  });
}

class MukaExceptionCapture {
  /// 请求错误
  final void Function(DioException) dioError;

  /// 异常错误
  final void Function(Object) error;

  const MukaExceptionCapture({
    this.dioError = _logger,
    this.error = _logger,
  });
}

void _logger(Object e) {
  logger.e(e);
}

class MukaConfig {
  static MukaConfigTheme config = MukaConfigTheme();
}
