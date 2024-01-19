part of flutter_muka;

class PageInit extends StatefulWidget {
  final Widget? child;

  /// 退出App提示
  final Function? onExitBefore;

  /// 退出到桌面
  final bool isBackToDesktop;

  /// 点击时间
  final Function(BuildContext)? onPageTap;

  const PageInit({
    Key? key,
    this.child,
    this.onExitBefore,
    this.isBackToDesktop = false,
    this.onPageTap,
  }) : super(key: key);

  @override
  _PageInitState createState() => _PageInitState();
}

class _PageInitState extends State<PageInit> {
  int _lastClickTime = 0;

  void _doubleExit() {
    int nowTime = DateTime.now().microsecondsSinceEpoch;
    if (widget.onExitBefore == null) {
      Navigator.pop(context);
      return;
    }
    if (_lastClickTime != 0 && nowTime - _lastClickTime > 1500) {
      /// 关闭APP
      SystemNavigator.pop(animated: true);
    } else {
      _lastClickTime = DateTime.now().microsecondsSinceEpoch;
      Future.delayed(const Duration(milliseconds: 1500), () {
        _lastClickTime = 0;
      });
      widget.onExitBefore?.call();
      return;
    }
  }

  @override
  void initState() {
    super.initState();
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.focusedChild?.unfocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        if (didPop) return;
        if (!didPop) {
          if (widget.isBackToDesktop) {
            if (Platform.isAndroid) {
              await BackToDesktop.backToDesktop();
              return;
            }
            Navigator.pop(context);
          } else {
            _doubleExit();
          }
        }
      },
      child: GestureDetector(
        onTap: () {
          if (widget.onPageTap == null) {
            FocusScopeNode currentFocus = FocusScope.of(context);
            if (!currentFocus.hasPrimaryFocus) {
              currentFocus.focusedChild?.unfocus();
            }
          } else {
            widget.onPageTap?.call(context);
          }
        },
        child: widget.child,
      ),
    );
  }
}
