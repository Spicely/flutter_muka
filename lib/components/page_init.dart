part of muka;

class PageInit extends StatefulWidget {
  final Widget? child;

  /// 退出App提示
  final String? exitLabel;

  const PageInit({Key? key, this.child, this.exitLabel}) : super(key: key);
  @override
  _PageInitState createState() => _PageInitState();
}

class _PageInitState extends State<PageInit> {
  int _lastClickTime = 0;

  Future<bool> _doubleExit() {
    int nowTime = DateTime.now().microsecondsSinceEpoch;
    if (widget.exitLabel == null) {
      return new Future.value(true);
    }
    if (_lastClickTime != 0 && nowTime - _lastClickTime > 1500) {
      return new Future.value(true);
    } else {
      _lastClickTime = DateTime.now().microsecondsSinceEpoch;
      Future.delayed(const Duration(milliseconds: 1500), () {
        _lastClickTime = 0;
      });
      toast(widget.exitLabel!);
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
