part of flutter_muka;

class ScanPage extends StatefulWidget {
  /// 允许读取相册
  final bool? isAlbum;

  final Color? scanLineColor;

  final String? title;

  const ScanPage({
    Key? key,
    this.isAlbum = true,
    this.scanLineColor,
    this.title,
  }) : super(key: key);

  @override
  _ScanPageState createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
  ScanController _controller = ScanController();

  ImagePicker _picker = ImagePicker();

  bool _status = true;

  @override
  void initState() {
    SystemChrome.setEnabledSystemUIOverlays([]);
    super.initState();
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    _controller.pause();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          ScanView(
            controller: _controller,
            scanAreaScale: .7,
            scanLineColor: widget.scanLineColor ?? Theme.of(context).primaryColor,
            onCapture: (String data) {
              Navigator.pop(context, data);
            },
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Theme(
              data: ThemeData(
                appBarTheme: Theme.of(context).appBarTheme.copyWith(
                      color: Colors.white,
                    ),
              ),
              child: AppBar(
                elevation: 0,
                title: Text(widget.title ?? '扫一扫'),
                centerTitle: true,
                backgroundColor: Colors.transparent,
                actions: widget.isAlbum ?? true
                    ? [
                        IconButton(
                          icon: Text('相册', style: TextStyle(color: Colors.white)),
                          onPressed: () async {
                            try {
                              _controller.pause();
                              PickedFile? pickedFile = await _picker.getImage(source: ImageSource.gallery);
                              if (pickedFile != null) {
                                String? data = await Scan.parse(pickedFile.path);
                                Navigator.pop(context, data);
                              }
                            } catch (e) {
                              _controller.resume();
                            }
                          },
                        ),
                      ]
                    : null,
              ),
            ),
          ),
          Positioned(
            bottom: MediaQuery.of(context).size.height * 0.16,
            left: 0,
            right: 0,
            child: Center(
              child: GestureDetector(
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Image.asset(
                        _status ? 'assets/images/light_open.png' : 'assets/images/light_off.png',
                        package: 'flutter_muka',
                        width: 35,
                      ),
                    ),
                    Text(_status ? '打开手电筒' : '关闭手电筒', style: TextStyle(color: Colors.white)),
                  ],
                ),
                onTap: () {
                  _controller.toggleTorchMode();
                  _status = !_status;
                  setState(() {});
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
