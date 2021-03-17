part of flutter_muka;

class CodeTime extends StatefulWidget {
  /// 倒计时的秒数，默认60秒
  final int countdown;

  /// 用户点击时的回调函数。
  final void Function() onTap;

  final CodeTimeController controller;

  /// 是否可以获取验证码，默认为`false`。
  final bool available;

  /// 初始值显示文本
  final String label;

  CodeTime({
    required this.controller,
    required this.onTap,
    this.countdown = 60,
    this.available = false,
    this.label = '获取验证码',
  });

  @override
  _CodeTimeState createState() => _CodeTimeState();
}

class _CodeTimeState extends State<CodeTime> {
  /// 倒计时的计时器。
  Timer? _timer;

  /// 当前倒计时的秒数。
  int _seconds = 0;

  // 当前是否可点击
  bool _available = true;

  /// 当前显示的文本。
  late String _label;

  /// 启动倒计时的计时器。
  void _startTimer() {
    // 计时器（`Timer`）组件的定期（`periodic`）构造函数，创建一个新的重复计时器。
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_seconds == 0) {
        _cancelTimer();
        _seconds = widget.countdown;
        setState(() {});
        return;
      }
      _seconds--;
      _label = '已发送$_seconds' + 's';
      setState(() {});
      if (_seconds == 0) {
        _label = '重新发送';
        _available = true;
      }
    });
  }

  /// 取消倒计时的计时器。
  void _cancelTimer() {
    // 计时器（`Timer`）组件的取消（`cancel`）方法，取消计时器。
    _timer?.cancel();
  }

  void didChangeDependencies() {
    super.didChangeDependencies();
    widget.controller._bindCodeTimeState(this);
  }

  @override
  void dispose() {
    _cancelTimer();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _seconds = widget.countdown;
    // inkWellStyle =const TextStyle(fontSize: 12, color: Theme.of(context).primaryColor);
  }

  @override
  Widget build(BuildContext context) {
    // 墨水瓶（`InkWell`）组件，响应触摸的矩形区域。
    return InkWell(
      child: Text('获取验证码', style: TextStyle(fontSize: 12, color: Theme.of(context).primaryColor)),
    );
  }
}

class CodeTimeController {
  _CodeTimeState? _codeTimeState;

  /// 绑定状态
  void _bindCodeTimeState(_CodeTimeState state) {
    this._codeTimeState = state;
  }

  /// 开始计时
  void start() {
    _codeTimeState!._startTimer();
  }

  /// 隐藏
  void cancel() {
    _codeTimeState!._cancelTimer();
  }

  /// 销毁
  void dispose() {
    this._codeTimeState = null;
  }
}
