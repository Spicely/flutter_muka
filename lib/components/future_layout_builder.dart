/*
 * Summary: 加载视图
 * Created Date: 2022-08-07 22:37:06
 * Author: Spicely
 * -----
 * Last Modified: 2022-08-17 00:51:24
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

// class FutureLayoutBuilder<T> extends StatelessWidget {
//   final Widget Function(T) builder;

//   final Function()? future;

//   final MukaFutureLayoutBuilderTheme? config;

//   late Future<T>? _future;

//   FutureLayoutBuilder({
//     Key? key,
//     required this.builder,
//     this.future,
//     this.config,
//   }) : super(key: key) {
//     _future = onFuture();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder<T>(
//       future: _future,
//       builder: (context, snapshot) {
//         if (snapshot.hasError) {
//           return config?.errorWidget(snapshot.data) ?? _futureLayoutBuilderTheme.errorWidget(snapshot.data);
//         } else if (snapshot.hasData) {
//           if (snapshot.data is Exception || snapshot.data is DioError) {
//             return config?.errorWidget(snapshot.data) ?? _futureLayoutBuilderTheme.errorWidget(snapshot.data);
//           } else {
//             return builder(snapshot.data!);
//           }
//         } else {
//           return config?.loadingWidget ?? _futureLayoutBuilderTheme.loadingWidget;
//         }
//       },
//     );
//   }

//   Future<T> onFuture() async {
//     dynamic res = await future?.call();
//     return res ?? true;
//   }
// }

class FutureLayoutBuilder<T> extends StatefulWidget {
  final Widget Function(T) builder;

  final Function()? future;

  final MukaFutureLayoutBuilderTheme? config;

  const FutureLayoutBuilder({
    Key? key,
    required this.builder,
    this.future,
    this.config,
  }) : super(key: key);
  @override
  _FutureLayoutBuilderState<T> createState() => _FutureLayoutBuilderState<T>();
}

class _FutureLayoutBuilderState<T> extends State<FutureLayoutBuilder<T>> {
  late Future<dynamic> _future;
  @override
  initState() {
    super.initState();
    _future = onFuture();
  }

  @override
  void didUpdateWidget(covariant FutureLayoutBuilder<T> oldWidget) {
    if (widget.future != oldWidget.future) {
      _future = onFuture();
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _future,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data is Exception || snapshot.data is DioError) {
            return widget.config?.errorWidget(snapshot.data) ?? _futureLayoutBuilderTheme.errorWidget(snapshot.data);
          } else {
            return widget.builder(snapshot.data);
          }
        } else if (snapshot.hasError) {
          return widget.config?.errorWidget(snapshot.data) ?? _futureLayoutBuilderTheme.errorWidget(snapshot.data);
        } else {
          return widget.config?.loadingWidget ?? _futureLayoutBuilderTheme.loadingWidget;
        }
      },
    );
  }

  Future<dynamic> onFuture() async {
    try {
      dynamic res = await widget.future?.call();
      return res ?? true;
    } catch (e) {
      return e;
    }
  }
}
