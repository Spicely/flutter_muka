part of flutter_muka;

/////////////////////////////////////////////////////////////////////////
//// All rights reserved.
//// author: Spicely
//// Summary: 启动页
//// Date: 2020年09月14日 23:55:03 Monday
//////////////////////////////////////////////////////////////////////////

/// 启动计时器位置
enum StartUpTimerType {
  /// 位于右上角
  top,

  /// 位于右下角
  bottom,
}

class StartUp extends StatefulWidget {
  /// 底部高度
  final double logoHeight;

  /// 背景颜色
  final Color color;

  /// 显示区视图
  final Widget child;

  /// 底部Logo视图
  final Widget? logo;

  /// 计时器位置
  final StartUpTimerType timer;

  /// 等待时间
  final int waitTime;

  /// 等待文本
  final String waitLabel;

  /// 计时完成或点击跳过回调
  final Function? onTimeEnd;

  /// 视图是否全屏
  final bool isFull;

  StartUp({
    Key? key,
    required this.child,
    this.logoHeight = 120,
    this.color = Colors.white,
    this.logo,
    this.timer = StartUpTimerType.top,
    this.waitTime = 3,
    this.waitLabel = '跳过',
    this.onTimeEnd,
    this.isFull = false,
  }) : super(key: key);
  @override
  _StartUpState createState() => _StartUpState();
}

class _StartUpState extends State<StartUp> {
  Timer? _timer;

  int _time = 0;

  @override
  void initState() {
    SystemChrome.setEnabledSystemUIOverlays([]);
    _time = widget.waitTime;
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_time == 0) {
        _timer?.cancel();
        widget.onTimeEnd?.call();
        return;
      }
      _time -= 1;
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // resizeToAvoidBottomPadding: false,
      backgroundColor: widget.color,
      body: Stack(
        children: [
          Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: Container(child: widget.child),
              ),
              Container(
                height: widget.isFull ? 0 : widget.logoHeight,
                child: widget.logo,
              ),
            ],
          ),
          Positioned(
            top: widget.timer == StartUpTimerType.top ? 40 : null,
            bottom: widget.timer == StartUpTimerType.bottom ? 40 : null,
            right: 20,
            child: GestureDetector(
              onTap: () {
                _timer?.cancel();
                widget.onTimeEnd?.call();
              },
              child: Container(
                alignment: Alignment.center,
                width: 60,
                height: 28,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(width: 0.1),
                ),
                child: Text('${widget.waitLabel} $_time'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
