/*
 * Summary: 加载视图
 * Created Date: 2022-08-07 22:37:06
 * Author: Spicely
 * -----
 * Last Modified: 2022-08-15 17:23:39
 * Modified By: Spicely
 * -----
 * Copyright (c) 2022 Spicely Inc.
 * 
 * May the force be with you.
 * -----
 * HISTORY:
 * Date      	By	Comments
 */

part of flutter_muka;

MukaFutureLayoutBuilderTheme _futureLayoutBuilderTheme = MukaConfig.config.futureLayoutBuilderTheme;

class FutureLayoutBuilder<T> extends StatelessWidget {
  final Widget Function(T) builder;

  final Function()? future;

  final MukaFutureLayoutBuilderTheme? config;

  late Future<T>? _future;

  FutureLayoutBuilder({
    Key? key,
    required this.builder,
    this.future,
    this.config,
  }) : super(key: key) {
    _future = onFuture();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<T>(
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return config?.errorWidget(snapshot.data) ?? _futureLayoutBuilderTheme.errorWidget(snapshot.data);
        } else if (snapshot.hasData) {
          if (snapshot.data is Exception || snapshot.data is DioError) {
            return config?.errorWidget(snapshot.data) ?? _futureLayoutBuilderTheme.errorWidget(snapshot.data);
          } else {
            return builder(snapshot.data!);
          }
        } else {
          return config?.loadingWidget ?? _futureLayoutBuilderTheme.loadingWidget;
        }
      },
    );
  }

  Future<T> onFuture() async {
    dynamic res = await future?.call();
    return res ?? true;
  }
}
