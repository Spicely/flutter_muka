part of flutter_muka;

String _render(int time) => '重新获取${time}s';

class CodeTime extends StatefulWidget {
  /// 倒计时的秒数，默认60秒
  final int countdown;

  /// 用户点击时的回调函数。
  final void Function() onTap;

  final CodeTimeController controller;

  /// 初始值显示文本
  final String label;

  /// 计时结束后显示文本
  final String endLabel;

  /// 计时时显示的内容
  final String Function(int time) render;

  final double? width;

  final double? height;

  final bool hasBorder;

  final double borderRadius;

  final EdgeInsetsGeometry padding;

  const CodeTime({
    required this.controller,
    required this.onTap,
    this.countdown = 60,
    this.label = '获取验证码',
    this.endLabel = '重新获取',
    this.height,
    this.width,
    this.hasBorder = false,
    this.borderRadius = 0,
    this.padding = const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
    this.render = _render,
  });

  @override
  _CodeTimeState createState() => _CodeTimeState();
}

class _CodeTimeState extends State<CodeTime> {
  /// 倒计时的计时器。
  Timer? _timer;

  /// 当前倒计时的秒数。
  int _seconds = 0;

  /// 当前是否可点击
  bool _available = true;

  /// 当前显示的文本。
  late String _label;

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
    _label = widget.label;
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      child: Container(
        padding: widget.padding,
        decoration: widget.hasBorder
            ? BoxDecoration(
                border: Border.all(
                  width: 1,
                  color: _available ? Theme.of(context).primaryColor : Theme.of(context).disabledColor,
                ),
                borderRadius: BorderRadius.circular(widget.borderRadius),
              )
            : null,
        width: widget.width,
        height: widget.height,
        child: Text(
          _label,
          style: TextStyle(fontSize: 12, color: _available ? Theme.of(context).primaryColor : Theme.of(context).disabledColor),
        ),
      ),
    );
  }

  /// 启动倒计时的计时器。
  Future<void> _startTimer(Function(CodeTimeHandle next) func) async {
    if (!_available) return;
    _available = false;
    Completer _completer = Completer();
    func(CodeTimeHandle(_completer));
    try {
      await _completer.future;
      _start();
    } catch (e) {
      _reset();
    }
  }

  void _start() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_seconds == 0) {
        _cancelTimer();
        _seconds = widget.countdown;
        setState(() {});
        return;
      }
      _seconds--;
      _label = widget.render.call(_seconds);
      setState(() {});
      if (_seconds == 0) {
        _label = widget.endLabel;
        _available = true;
      }
    });
  }

  /// 取消倒计时的计时器。
  void _cancelTimer() {
    _timer?.cancel();
  }

  /// 重置
  void _reset() {
    _timer?.cancel();
    _available = true;
    _seconds = widget.countdown;
    _label = widget.label;
    setState(() {});
  }
}

class CodeTimeHandle {
  final Completer _completer;

  const CodeTimeHandle(this._completer);

  /// 成功 [开始计时]
  void resolve() {
    _completer.complete('ok');
  }

  /// 失败 [不计时]
  void reject() {
    _completer.completeError('error');
  }
}

class CodeTimeController {
  _CodeTimeState? _codeTimeState;

  /// 绑定状态
  void _bindCodeTimeState(_CodeTimeState state) {
    this._codeTimeState = state;
  }

  /// 开始计时
  void start(Function(CodeTimeHandle next) func) {
    _codeTimeState!._startTimer(func);
  }

  /// 重置
  void reset() {
    _codeTimeState!._reset();
  }

  /// 销毁
  void dispose() {
    this._codeTimeState = null;
  }
}
