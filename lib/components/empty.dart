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
}

enum EmptyBtnType {
  outlined,
  elevated,
}

class Empty extends StatefulWidget {
  Empty({
    Key? key,
    this.controller,
    this.child,
    this.empty,
    this.extend,
    this.network,
    this.type = EmptyType.content,
    this.notContent = const EmptyNotContent(),
    this.onReload,
    this.onTap,
    this.btnText = '返回',
    this.btnType = EmptyBtnType.outlined,
    this.btnStyle,
    this.btnTextStyle,
  })  : assert(Empty.GLOBAL_EMPTY_DATA_URL.isNotEmpty, '你需要至少保证全局空数据图片地址或无数据填充其中一个有值'),
        assert(Empty.GLOBAL_NOT_NETWORK_URL.isNotEmpty || network != null, '你需要至少保证全局无网络图片地址或无网络填充其中一个有值'),
        super(key: key);

  /// 无内容图片地址
  ///
  /// 本地图片地址
  // ignore: non_constant_identifier_names
  static String GLOBAL_EMPTY_DATA_URL = '';

  /// 无网络图片地址
  ///
  /// 本地图片地址
  // ignore: non_constant_identifier_names
  static String GLOBAL_NOT_NETWORK_URL = '';

  /// 没有消息图片地址
  ///
  /// 本地图片地址
  // ignore: non_constant_identifier_names
  static String GLOBAL_NOT_MSG_URL = '';

  /// 没有订单图片地址
  ///
  /// 本地图片地址
  // ignore: non_constant_identifier_names
  static String GLOBAL_NOT_ORDER_URL = '';

  /// 没有搜索结果图片地址
  ///
  /// 本地图片地址
  // ignore: non_constant_identifier_names
  static String GLOBAL_NOT_SEARCH_URL = '';

  /// 全局图片宽度
  // ignore: non_constant_identifier_names
  static double IMG_WIDTH = 120.0;

  /// 控制器
  final EmptyController? controller;

  final Widget? child;

  /// 无网络填充
  final Widget? extend;

  /// 无数据填充
  final Widget? empty;

  /// 无网络填充
  final Widget? network;

  /// 填充内容
  final EmptyType type;

  /// 重新加载
  final GestureTapCallback? onReload;

  /// 点击处理
  final GestureTapCallback? onTap;

  final EmptyNotContent notContent;

  final String btnText;

  final EmptyBtnType btnType;

  final ButtonStyle? btnStyle;

  final TextStyle? btnTextStyle;

  @override
  State<StatefulWidget> createState() => _EmptyState();
}

class _EmptyState extends State<Empty> {
  /// 错误状态
  ///
  /// true显示 false 不显示
  bool _status = false;

  /// 网络状态
  ///
  /// true 有网络 false 无网络
  bool _network = true;

  @override
  initState() {
    super.initState();
    if (widget.controller == null) {
      Future.delayed(Duration(microseconds: 500), () async {
        _network = await _getNetwork();
        if (widget.child == null) {
          _status = true;
        }
        setState(() {});
      });
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    widget.controller?._bindEmptyState(this);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Offstage(
          offstage: !_status,
          child: Container(
            width: double.infinity,
            height: double.infinity,
            alignment: Alignment.center,
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _getImage(),
                  widget.extend ??
                      Column(
                        children: [
                          Container(
                            alignment: Alignment.center,
                            padding: EdgeInsets.only(top: 10),
                            child: Text(_getTypeText()),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 10),
                            child: widget.btnType == EmptyBtnType.outlined
                                ? OutlinedButton(
                                    child: Text(
                                      _network ? '重试' : widget.btnText,
                                      style: widget.btnTextStyle ?? TextStyle(color: Colors.white),
                                    ),
                                    style: widget.btnStyle ??
                                        ButtonStyle(
                                          elevation: MaterialStateProperty.all(0),
                                          shape: MaterialStateProperty.all(
                                            RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                                          ),
                                        ),
                                    onPressed: () {
                                      if (_network) {
                                        widget.onReload?.call();
                                      } else {
                                        widget.onTap?.call();
                                      }
                                    },
                                  )
                                : ElevatedButton(
                                    child: Text(
                                      _network ? '重试' : widget.btnText,
                                      style: widget.btnTextStyle ?? TextStyle(color: Colors.black38),
                                    ),
                                    style: widget.btnStyle ??
                                        ButtonStyle(
                                          elevation: MaterialStateProperty.all(0),
                                          shape: MaterialStateProperty.all(
                                            RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                                          ),
                                          side: MaterialStateProperty.all(BorderSide(color: Colors.black38)),
                                        ),
                                    onPressed: () {
                                      if (_network) {
                                        widget.onReload?.call();
                                      } else {
                                        widget.onTap?.call();
                                      }
                                    },
                                  ),
                          ),
                        ],
                      )
                ],
              ),
            ),
          ),
        ),
        widget.child ?? Container(),
      ],
    );
  }

  Widget _getImage() {
    if (_network) {
      return widget.empty ??
          Image.asset(
            _globalAsset(),
            width: Empty.IMG_WIDTH,
          );
    }
    return widget.network ?? Image.asset(Empty.GLOBAL_NOT_NETWORK_URL, width: Empty.IMG_WIDTH);
  }

  String _getTypeText() {
    switch (widget.type) {
      case EmptyType.search:
        return widget.notContent.search;
      case EmptyType.order:
        return widget.notContent.order;
      case EmptyType.msg:
        return widget.notContent.msg;
      default:
        return widget.notContent.content;
    }
  }

  String _globalAsset() {
    switch (widget.type) {
      case EmptyType.search:
        return Empty.GLOBAL_NOT_SEARCH_URL;
      case EmptyType.order:
        return Empty.GLOBAL_NOT_ORDER_URL;
      case EmptyType.msg:
        return Empty.GLOBAL_NOT_MSG_URL;
      default:
        return Empty.GLOBAL_EMPTY_DATA_URL;
    }
  }

  Future<bool> _getNetwork() async {
    ConnectivityResult connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      return false;
    }
    return true;
  }

  void _setVisible(bool status) async {
    _status = status;
    if (status) {
      _network = await _getNetwork();
    }
    setState(() {});
  }
}

class EmptyController {
  _EmptyState? _easyState;

  /// 绑定状态
  void _bindEmptyState(_EmptyState state) {
    this._easyState = state;
  }

  /// 显示
  void show() {
    _easyState!._setVisible(true);
  }

  /// 隐藏
  void hide() {
    _easyState!._setVisible(false);
  }

  /// 销毁
  void dispose() {
    this._easyState = null;
  }
}

/// 没有数据显示的文本
class EmptyNotContent {
  /// 显示无内容时文本
  final String content;

  /// 显示无搜索时文本
  final String search;

  /// 显示无消息时文本
  final String msg;

  /// 显示无订单时文本
  final String order;

  const EmptyNotContent({
    this.content = '暂无内容',
    this.search = '暂无搜索结果',
    this.msg = '暂无消息',
    this.order = '暂无订单',
  });

  EmptyNotContent copyWith({
    String? content,
    String? search,
    String? msg,
    String? order,
  }) {
    return EmptyNotContent(
      content: content ?? this.content,
      search: search ?? this.search,
      msg: msg ?? this.msg,
      order: order ?? this.order,
    );
  }
}
