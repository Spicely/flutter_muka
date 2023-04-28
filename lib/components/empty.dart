part of flutter_muka;

/////////////////////////////////////////////////////////////////////////
//// All rights reserved.
//// author: Spicely
//// Summary: 空组件样式
//// Date: 2020年06月19日 20:33:24 Friday
//////////////////////////////////////////////////////////////////////////

/// 显示类型
enum EmptyType {
  /// 无内容
  content,

  /// 无消息
  msg,

  /// 无搜索结果
  search,

  /// 没有订单
  order,

  /// 没有购物车
  cart,
}

enum EmptyBtnType {
  outlined,
  elevated,
  none,
}

class Empty extends StatefulWidget {
  final bool? isEmpty;

  final Widget? child;

  /// 空组件样式
  final Widget? emptyChild;
  Empty({
    Key? key,
    this.child,
    this.emptyChild,
    this.isEmpty,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _EmptyState();
}

class _EmptyState extends State<Empty> {
  /// 错误状态
  ///
  /// true显示 false 不显示
  bool _status = false;

  @override
  initState() {
    _status = widget.isEmpty ?? false;
    super.initState();
  }

  @override
  void didUpdateWidget(covariant Empty oldWidget) {
    if (oldWidget.isEmpty != _status) {
      setState(() {
        _status = widget.isEmpty ?? false;
      });
    }
    super.didUpdateWidget(oldWidget);
  }

  /// 网络状态
  ///
  /// true 有网络 false 无网络
  // bool _network = true;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        if (widget.child != null) widget.child!,
        Offstage(
          offstage: widget.isEmpty == null ? !_status : !widget.isEmpty!,
          child: Container(
            width: double.infinity,
            height: double.infinity,
            alignment: Alignment.center,
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  widget.emptyChild ?? MukaConfig.config.emptyWidget(context),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  // Future<bool> _getNetwork() async {
  //   ConnectivityResult connectivityResult = await Connectivity().checkConnectivity();
  //   if (connectivityResult == ConnectivityResult.none) {
  //     return false;
  //   }
  //   return true;
  // }
}

class SliverEmpty extends StatelessWidget {
  final Widget child;

  /// 空组件样式
  final Widget? emptyChild;

  final bool isEmpty;

  const SliverEmpty({
    Key? key,
    required this.child,
    this.emptyChild,
    this.isEmpty = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (isEmpty) {
      return emptyChild ??
          SliverToBoxAdapter(
            child: MukaConfig.config.emptyWidget(context),
          );
    }
    return child;
  }
}
