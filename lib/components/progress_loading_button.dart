part of flutter_muka;

enum ProgressLoadingButtonState {
  loading,
  error,
  success,
}

class ProgressLoadingButton extends StatefulWidget {
  final Future<ProgressLoadingButtonState> Function() onPressed;

  /// 触发点击事件之前
  final bool Function()? onPressedBefore;

  // 失败显示时间
  final Duration errorTime;

  // 加载延迟时间
  final Duration loadingDelayedTime;

  // 完成后事件
  final void Function()? onSuccess;

  final Widget? loadingWidget;

  final Widget? errorWidget;

  final Widget? successWidget;

  final Widget idleWidget;

  /// null 代表不需要变回初始状态
  final Duration? successDelayedTime;

  final Duration onSuccessDelayedTime;

  const ProgressLoadingButton({
    Key? key,
    required this.onPressed,
    required this.idleWidget,
    this.errorTime = const Duration(seconds: 2),
    this.loadingDelayedTime = const Duration(seconds: 2),
    this.onSuccessDelayedTime = const Duration(seconds: 2),
    this.loadingWidget,
    this.errorWidget,
    this.successWidget,
    this.successDelayedTime,
    this.onPressedBefore,
    this.onSuccess,
  }) : super(key: key);

  @override
  _ProgressLoadingButtonState createState() => _ProgressLoadingButtonState();
}

class _ProgressLoadingButtonState extends State<ProgressLoadingButton> {
  ProgressLoadingButtonState? _state;

  /// 倒计时的计时器。
  Timer? _timer;

  @override
  void dispose() {
    _timer?.cancel();
    _timer = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      child: _getStateWidge(),
      onPressed: () {
        if (!(widget.onPressedBefore?.call() ?? true)) {
          return;
        }
        if (_state != null) return;
        _state = ProgressLoadingButtonState.loading;
        _timer = Timer.periodic(widget.loadingDelayedTime, (timer) async {
          _state = await widget.onPressed();
          _timer?.cancel();
          _timer = null;
          setState(() {});
        });
        setState(() {});
      },
    );
  }

  Widget _getStateWidge() {
    switch (_state) {
      case ProgressLoadingButtonState.error:
        _timer = Timer.periodic(widget.errorTime, (timer) {
          _state = null;
          _timer?.cancel();
          _timer = null;
          setState(() {});
        });
        return widget.errorWidget ??
            Row(
              mainAxisSize: MainAxisSize.min,
              children: const [Icon(Icons.highlight_off), Text('错误')],
            );
      case ProgressLoadingButtonState.loading:
        return widget.loadingWidget ?? const SpinKitThreeBounce(color: Colors.white, size: 25);
      case ProgressLoadingButtonState.success:
        if (widget.successDelayedTime != null) {
          _timer = Timer.periodic(widget.successDelayedTime!, (timer) {
            _state = null;
            _timer?.cancel();
            _timer = null;
            setState(() {
              _onSuccess();
            });
          });
        } else {
          _onSuccess();
        }

        return widget.successWidget ??
            Row(
              mainAxisSize: MainAxisSize.min,
              children: const [Icon(Icons.check_circle_outline_outlined), Text('成功')],
            );
      default:
        return widget.idleWidget;
    }
  }

  void _onSuccess() {
    if (widget.onSuccess != null) {
      _timer = Timer.periodic(widget.onSuccessDelayedTime, (timer) {
        _timer?.cancel();
        _timer = null;
        widget.onSuccess?.call();
      });
    }
  }
}
