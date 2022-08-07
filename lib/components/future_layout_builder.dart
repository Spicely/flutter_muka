/*
 * Summary: 加载视图
 * Created Date: 2022-08-07 22:37:06
 * Author: Spicely
 * -----
 * Last Modified: 2022-08-07 23:10:17
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

class FutureLayoutBuilder extends StatelessWidget {
  final Widget child;

  final Future<dynamic>? future;

  final MukaFutureLayoutBuilderTheme? config;

  const FutureLayoutBuilder({
    Key? key,
    required this.child,
    this.future,
    this.config,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: onFuture(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data is bool) {
            return child;
          } else {
            return config?.errorWidget(snapshot.data) ?? _futureLayoutBuilderTheme.errorWidget(snapshot.data);
          }
        } else if (snapshot.hasError) {
          return config?.errorWidget(snapshot.data) ?? _futureLayoutBuilderTheme.errorWidget(snapshot.data);
        } else {
          return config?.loadingWidget ?? _futureLayoutBuilderTheme.loadingWidget;
        }
      },
    );
  }

  Future<dynamic> onFuture() async {
    try {
      await future;
      return true;
    } catch (e) {
      return e;
    }
  }
}
