part of muka;

class SignatureView extends StatefulWidget {
  /// 钢笔颜色
  final Color penColor;

  /// 背景颜色
  final Color background;

  /// 画笔大小
  final double penStrokeWidth;

  const SignatureView({
    Key? key,
    this.penColor = Colors.black,
    this.background = Colors.white,
    this.penStrokeWidth = 4,
  }) : super(key: key);
  @override
  _SignatureViewState createState() => _SignatureViewState();
}

class _SignatureViewState extends State<SignatureView> {
  late SignatureController _controller;

  @override
  void initState() {
    _controller = SignatureController(
      penStrokeWidth: widget.penStrokeWidth,
      penColor: widget.penColor,
      exportBackgroundColor: widget.background,
    );
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeLeft,
    ]);
    SystemChrome.setEnabledSystemUIOverlays([]);
  }

  @override
  void dispose() {
    _controller.dispose();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Signature(
            controller: _controller,
            width: double.infinity,
            height: double.infinity,
            backgroundColor: widget.background,
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Row(
              children: [
                Expanded(
                  child: Container(color: Colors.transparent),
                ),
                IconButton(
                  icon: Text('清除'),
                  onPressed: () {
                    _controller.clear();
                  },
                ),
                IconButton(
                  icon: Icon(Icons.close, color: Colors.red),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                IconButton(
                  icon: Icon(Icons.done, color: Colors.green),
                  onPressed: () async {
                    Uint8List image = await _controller.toPngBytes();
                    Navigator.pop(context, image);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
