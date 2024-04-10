part of flutter_muka;

class WindowBar extends StatefulWidget {
  final bool exitApp;

  const WindowBar({Key? key, this.exitApp = true});

  @override
  State<WindowBar> createState() => _WinBarState();
}

class _WinBarState extends State<WindowBar> with WindowListener {
  bool isWinMax = false;

  @override
  void initState() {
    super.initState();
    windowManager.addListener(this);
    windowManager.isMaximized().then((v) {
      setState(() {
        isWinMax = v;
      });
    });
  }

  @override
  void dispose() {
    windowManager.removeListener(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 35,
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onPanStart: startDragging,
              onDoubleTap: Platform.isMacOS ? null : resetWindow,
              child: Container(),
            ),
          ),
          if (!Platform.isMacOS)
            Wrap(
              spacing: 2,
              children: [
                IconButton(
                  iconSize: 16,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(minWidth: 35, minHeight: 35),
                  icon: const Icon(Icons.remove_rounded),
                  onPressed: windowManager.minimize,
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all(const RoundedRectangleBorder(borderRadius: BorderRadius.zero)),
                  ),
                ),
                IconButton(
                  iconSize: 16,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(minWidth: 35, minHeight: 35),
                  icon: Icon(isWinMax ? Icons.fullscreen_exit_rounded : Icons.fullscreen_rounded),
                  onPressed: isWinMax ? windowManager.restore : windowManager.maximize,
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all(const RoundedRectangleBorder(borderRadius: BorderRadius.zero)),
                  ),
                ),
                IconButton(
                  iconSize: 16,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(minWidth: 35, minHeight: 35),
                  icon: const Icon(Icons.close_rounded),
                  onPressed: widget.exitApp ? windowManager.destroy : windowManager.hide,
                  hoverColor: Colors.red,
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all(const RoundedRectangleBorder(borderRadius: BorderRadius.zero)),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  @override
  void onWindowMaximize() {
    setState(() {
      isWinMax = true;
    });
  }

  @override
  void onWindowUnmaximize() {
    setState(() {
      isWinMax = false;
    });
  }

  void startDragging(_) {
    windowManager.startDragging();
  }

  /// 修改窗口大小
  void resetWindow() {
    if (isWinMax) {
      windowManager.restore();
    } else {
      windowManager.maximize();
    }
  }
}
