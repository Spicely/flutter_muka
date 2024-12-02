part of flutter_muka;

class WindowBarManager {
  static final ObserverList<WinBarState> _listeners = ObserverList<WinBarState>();

  static List<WinBarState> get listeners {
    final List<WinBarState> localListeners = List<WinBarState>.from(_listeners);
    return localListeners;
  }

  static bool get hasListeners {
    return _listeners.isNotEmpty;
  }

  static void addListener(WinBarState listener) {
    _listeners.add(listener);
  }

  static void removeListener(WinBarState listener) {
    _listeners.remove(listener);
  }

  static void update() {
    for (final listener in _listeners) {
      listener.update();
    }
  }
}

class WindowBar extends StatefulWidget {
  static double barHeight = Platform.isMacOS ? 10 : 30;

  final bool exitApp;

  final double size;

  final GlobalKey<NavigatorState>? navigatorKey;

  const WindowBar({
    Key? key,
    this.exitApp = true,
    this.size = 30,
    this.navigatorKey,
  });

  @override
  State<WindowBar> createState() => WinBarState();
}

class WinBarState extends State<WindowBar> with WindowListener {
  bool isWinMax = false;

  @override
  void initState() {
    super.initState();
    windowManager.addListener(this);
    WindowBarManager.addListener(this);
    windowManager.isMaximized().then((v) {
      setState(() {
        isWinMax = v;
      });
    });
  }

  @override
  void dispose() {
    windowManager.removeListener(this);
    WindowBarManager.removeListener(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: WindowBar.barHeight,
      child: Row(
        children: [
          if (widget.navigatorKey?.currentState?.canPop() ?? false)
            IconButton(
              iconSize: 16,
              padding: EdgeInsets.zero,
              constraints: BoxConstraints(minWidth: widget.size, minHeight: widget.size),
              icon: const Icon(Icons.arrow_back_rounded),
              onPressed: () {
                widget.navigatorKey?.currentState?.pop();
              },
              style: ButtonStyle(
                shape: WidgetStateProperty.all(const RoundedRectangleBorder(borderRadius: BorderRadius.zero)),
              ),
            ),
          Expanded(
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onPanStart: startDragging,
              onDoubleTap: Platform.isMacOS ? null : resetWindow,
              child: SizedBox.expand(),
            ),
          ),
          if (!Platform.isMacOS)
            Wrap(
              spacing: 2,
              children: [
                IconButton(
                  iconSize: 16,
                  padding: EdgeInsets.zero,
                  constraints: BoxConstraints(minWidth: widget.size, minHeight: widget.size),
                  icon: const Icon(Icons.remove_rounded),
                  onPressed: windowManager.minimize,
                  style: ButtonStyle(
                    shape: WidgetStateProperty.all(const RoundedRectangleBorder(borderRadius: BorderRadius.zero)),
                  ),
                ),
                IconButton(
                  iconSize: 16,
                  padding: EdgeInsets.zero,
                  constraints: BoxConstraints(minWidth: widget.size, minHeight: widget.size),
                  icon: Icon(isWinMax ? Icons.fullscreen_exit_rounded : Icons.fullscreen_rounded),
                  onPressed: isWinMax ? windowManager.restore : windowManager.maximize,
                  style: ButtonStyle(
                    shape: WidgetStateProperty.all(const RoundedRectangleBorder(borderRadius: BorderRadius.zero)),
                  ),
                ),
                IconButton(
                  iconSize: 16,
                  padding: EdgeInsets.zero,
                  constraints: BoxConstraints(minWidth: widget.size, minHeight: widget.size),
                  icon: const Icon(Icons.close_rounded),
                  onPressed: widget.exitApp ? windowManager.destroy : windowManager.hide,
                  hoverColor: Colors.red,
                  style: ButtonStyle(
                    shape: WidgetStateProperty.all(const RoundedRectangleBorder(borderRadius: BorderRadius.zero)),
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

  void update() {
    if (mounted) {
      setState(() {});
    }
  }
}
