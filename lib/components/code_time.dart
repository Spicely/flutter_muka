part of muka;

class CodeTime extends StatefulWidget {
  /// 倒计时的秒数，默认60秒
  final int countdown;

  /// 用户点击时的回调函数。
  Future<bool> Function() onTap;

  /// 是否否可以获取验证码，默认为`false`。
  final bool available;

  /// 墨水瓶（`InkWell`）不可用时使用的样式。
  final TextStyle unavailableStyle;

  /// 当前墨水瓶（`InkWell`）的字体样式。
  final TextStyle inkWellStyle;

  CodeTime({
    @required this.onTap,
    this.countdown = 60,
    this.available = false,
    this.unavailableStyle = const TextStyle(
      fontSize: 12.0,
      color: const Color(0xFFCCCCCC),
    ),
    this.inkWellStyle = const TextStyle(
      fontSize: 12.0,
      color: const Color(0xFF00CACE),
    ),
  });

  @override
  _CodeTimeState createState() => _CodeTimeState();
}

class _CodeTimeState extends State<CodeTime> {
  /// 倒计时的计时器。
  Timer _timer;

  /// 当前倒计时的秒数。
  int _seconds;

  // 当前是否可点击
  bool _available = true;

  /// 当前墨水瓶（`InkWell`）的字体样式。
  TextStyle inkWellStyle = TextStyle(
    fontSize: 12.0,
    color: const Color(0xFF00CACE),
  );

  /// 当前墨水瓶（`InkWell`）的文本。
  String _verifyStr = '获取验证码';

  @override
  void initState() {
    super.initState();
    _seconds = widget.countdown;
  }

  /// 启动倒计时的计时器。
  void _startTimer() {
    // 计时器（`Timer`）组件的定期（`periodic`）构造函数，创建一个新的重复计时器。
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_seconds == 0) {
        _cancelTimer();
        _seconds = widget.countdown;
        inkWellStyle = widget.inkWellStyle;
        setState(() {});
        return;
      }
      _seconds--;
      _verifyStr = '已发送$_seconds' + 's';
      setState(() {});
      if (_seconds == 0) {
        _verifyStr = '重新发送';
        _available = true;
      }
    });
  }

  /// 取消倒计时的计时器。
  void _cancelTimer() {
    // 计时器（`Timer`）组件的取消（`cancel`）方法，取消计时器。
    _timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    // 墨水瓶（`InkWell`）组件，响应触摸的矩形区域。
    return widget.available
        ? InkWell(
            child: Text(
              '$_verifyStr',
              style: inkWellStyle,
            ),
            onTap: _available
                ? () async {
                    bool status = await widget.onTap();
                    if (status) {
                      _available = false;
                      _startTimer();
                      inkWellStyle = widget.unavailableStyle;
                      _verifyStr = '已发送$_seconds' + 's';
                      setState(() {}); // 触发视图更新
                    }
                  }
                : null,
          )
        : InkWell(child: Text('获取验证码', style: widget.unavailableStyle));
  }
}
