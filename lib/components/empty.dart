part of muka;

/////////////////////////////////////////////////////////////////////////
//// All rights reserved.
//// author: Spicely
//// Summary: 空组件样式
//// Date: 2020年06月19日 20:33:24 Friday
//////////////////////////////////////////////////////////////////////////
class Empty extends StatefulWidget {
  Empty({@required this.initLoad, this.child, this.empty, this.network})
      : assert(initLoad != null, '初始请求必须填写'),
        assert(GLOBAL_EMPTY_DATA_URL.isNotEmpty || empty != null, '你需要至少保证全局空数据图片地址或无数据填充其中一个有值'),
        assert(GLOBAL_NOT_NETWORK_URL.isNotEmpty || network != null, '你需要至少保证全局无网络图片地址或无网络填充其中一个有值');

  /// 空数据图片地址
  ///
  /// 本地图片地址
  static String GLOBAL_EMPTY_DATA_URL = '';

  /// 无网络图片地址
  ///
  /// 本地图片地址
  static String GLOBAL_NOT_NETWORK_URL = '';

  /// 全局图片宽度
  static double IMG_WIDTH = 120.0;

  /// 初始请求
  ///
  /// 需要返回状态
  ///
  /// true 成功不显示 false 失败显示图片
  final Future<bool> Function() initLoad;

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
  /// true不显示 false 显示
  bool _status = true;

  /// 网络状态
  ///
  /// true 有网络 false 无网络
  bool _network = true;

  @override
  initState() {
    super.initState();
    Future.delayed(Duration(microseconds: 500), () async {
      _status = await widget.initLoad();
      ConnectivityResult connectivityResult = await Connectivity().checkConnectivity();
      if (connectivityResult == ConnectivityResult.none) {
        _network = false;
      }
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        widget.child ?? Container(),
        Offstage(
          offstage: _status,
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
      return widget.empty ?? Image.asset(Empty.GLOBAL_EMPTY_DATA_URL, width: Empty.IMG_WIDTH,);
    }
    return widget.network ?? Image.asset(Empty.GLOBAL_NOT_NETWORK_URL, width: Empty.IMG_WIDTH);
  }
}
