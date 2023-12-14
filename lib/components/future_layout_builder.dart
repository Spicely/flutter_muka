/*
 * Summary: 加载视图
 * Created Date: 2022-08-07 22:37:06
 * Author: Spicely
 * -----
 * Last Modified: 2022-10-08 21:08:47
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

class FutureLayoutBuilderController {
  _FutureLayoutBuilderState? _state;

  FutureLayoutBuilderController();

  /// 重载
  void reload() {
    _state?.reload();
  }

  /// 绑定状态
  void _bindState(_FutureLayoutBuilderState state) {
    this._state = state;
  }
}

class FutureLayoutBuilder<T> extends StatefulWidget {
  final Widget Function(T) builder;

  final Function()? future;

  final FutureLayoutBuilderController? controller;

  final MukaFutureLayoutBuilderTheme? config;

  /// 是否需要拉取
  final T? data;

  const FutureLayoutBuilder({
    Key? key,
    required this.builder,
    this.future,
    this.config,
    this.data,
    this.controller,
  }) : super(key: key);
  @override
  _FutureLayoutBuilderState<T> createState() => _FutureLayoutBuilderState<T>();
}

class _FutureLayoutBuilderState<T> extends State<FutureLayoutBuilder<T>> {
  late Future<dynamic> _future;
  @override
  initState() {
    super.initState();
    widget.controller?._bindState(this);
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
  void didChangeDependencies() {
    super.didChangeDependencies();
    widget.controller?._bindState(this);
  }

  @override
  Widget build(BuildContext context) {
    MukaFutureLayoutBuilderTheme _futureLayoutBuilderTheme = MukaConfig.config.futureLayoutBuilderTheme;
    if (widget.data != null) {
      return widget.builder(widget.data!);
    }
    return FutureBuilder(
      future: _future,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data is Error || snapshot.data is DioException || snapshot.data is MissingPluginException) {
            return widget.config?.errorWidget(context, snapshot.data, reload) ?? _futureLayoutBuilderTheme.errorWidget(context, snapshot.data, reload);
          } else {
            return widget.builder(snapshot.data);
          }
        } else if (snapshot.hasError) {
          return widget.config?.errorWidget(context, snapshot.data, reload) ?? _futureLayoutBuilderTheme.errorWidget(context, snapshot.data, reload);
        } else {
          return widget.config?.loadingWidget(context) ?? _futureLayoutBuilderTheme.loadingWidget(context);
        }
      },
    );
  }

  void reload() {
    _future = onFuture();
    setState(() {});
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
