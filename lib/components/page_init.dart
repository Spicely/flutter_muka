part of flutter_muka;

class PageInit extends StatefulWidget {
  final Widget? child;

  /// 退出App提示
  final Function? onExitBefore;

  /// 退出到桌面
  final bool isBackToDesktop;

  /// 点击时间
  final Function? onPageTap;

  const PageInit({
    Key? key,
    this.child,
    this.onExitBefore,
    this.isBackToDesktop = false,
    this.onPageTap,
  }) : super(key: key);

  /// 是否阻止事件
  static bool _isStopEvent = false;

  /// 阻止事件
  static void stopEvent() {
    _isStopEvent = true;
  }

  /// 开启事件
  static void startEvent() {
    _isStopEvent = false;
  }

  @override
  _PageInitState createState() => _PageInitState();
}

class _PageInitState extends State<PageInit> {
  int _lastClickTime = 0;

  Future<bool> _doubleExit() {
    int nowTime = DateTime.now().microsecondsSinceEpoch;
    if (widget.onExitBefore == null) {
      return Future.value(true);
    }
    if (_lastClickTime != 0 && nowTime - _lastClickTime > 1500) {
      return Future.value(true);
    } else {
      _lastClickTime = DateTime.now().microsecondsSinceEpoch;
      Future.delayed(const Duration(milliseconds: 1500), () {
        _lastClickTime = 0;
      });
      widget.onExitBefore?.call();
      return Future.value(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: widget.isBackToDesktop
          ? () async {
              /// 判断是否为根页面
              if (Navigator.of(context).canPop()) {
                return true;
              }
              if (Platform.isAndroid) {
                await BackToDesktop.backToDesktop();
                return false;
              }
              return true;
            }
          : _doubleExit,
      child: GestureDetector(
        onTap: () {
          if (!PageInit._isStopEvent) {
            FocusScopeNode currentFocus = FocusScope.of(context);
            if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
              FocusManager.instance.primaryFocus?.unfocus();
            }
          }
          widget.onPageTap?.call();
        },
        child: widget.child,
      ),
    );
  }
}
