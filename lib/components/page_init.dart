part of flutter_muka;

class PageInit extends StatefulWidget {
  final Widget? child;

  /// 退出App提示
  final Function? onExitBefore;

  const PageInit({
    Key? key,
    this.child,
    this.onExitBefore,
  }) : super(key: key);

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
      onWillPop: _doubleExit,
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: widget.child,
      ),
    );
  }
}
