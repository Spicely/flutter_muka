part of muka;

/////////////////////////////////////////////////////////////////////////
//// All rights reserved.
//// author: Spicely
//// Summary: 空组件样式
//// Date: 2020年06月19日 20:33:24 Friday
//////////////////////////////////////////////////////////////////////////
class Empty extends StatefulWidget {
  Empty({this.controller, this.child, this.empty, this.network})
      : assert(GLOBAL_EMPTY_DATA_URL.isNotEmpty || empty != null, '你需要至少保证全局空数据图片地址或无数据填充其中一个有值'),
        assert(GLOBAL_NOT_NETWORK_URL.isNotEmpty || network != null, '你需要至少保证全局无网络图片地址或无网络填充其中一个有值');

  /// 空数据图片地址
  ///
  /// 本地图片地址
  // ignore: non_constant_identifier_names
  static String GLOBAL_EMPTY_DATA_URL = '';

  /// 无网络图片地址
  ///
  /// 本地图片地址
  // ignore: non_constant_identifier_names
  static String GLOBAL_NOT_NETWORK_URL = '';

  /// 全局图片宽度
  // ignore: non_constant_identifier_names
  static double IMG_WIDTH = 120.0;

  /// 控制器
  final EmptyController controller;

  final Widget child;

  /// 无数据填充
  final Widget empty;

  /// 无网络填充
  final Widget network;

  @override
  State<StatefulWidget> createState() => _EmptyState();
}

class _EmptyState extends State<Empty> {
  /// 错误状态
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
    widget.controller._bindEmptyState(this);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        widget.child ?? Container(),
        Offstage(
          offstage: !_status,
          child: Container(
            width: double.infinity,
            height: double.infinity,
            alignment: Alignment.center,
            child: _getImage(),
          ),
        ),
      ],
    );
  }

  Widget _getImage() {
    if (_network) {
      return widget.empty ??
          Image.asset(
            Empty.GLOBAL_EMPTY_DATA_URL,
            width: Empty.IMG_WIDTH,
          );
    }
    return widget.network ?? Image.asset(Empty.GLOBAL_NOT_NETWORK_URL, width: Empty.IMG_WIDTH);
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
  _EmptyState _easyState;

  /// 绑定状态
  void _bindEmptyState(_EmptyState state) {
    this._easyState = state;
  }

  /// 显示
  void show() {
    _easyState._setVisible(true);
  }

  /// 隐藏
  void hide() {
    _easyState._setVisible(false);
  }

  /// 销毁
  void dispose() {
    this._easyState = null;
  }
}
