import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:scan/scan.dart';

class ScanPage extends StatefulWidget {
  /// 允许读取相册
  final bool? isAlbum;

  final Color? scanLineColor;

  const ScanPage({
    Key? key,
    this.isAlbum = true,
    this.scanLineColor,
  }) : super(key: key);

  @override
  _ScanPageState createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
  ScanController _controller = ScanController();

  ImagePicker _picker = ImagePicker();

  bool _status = true;

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
            child: AppBar(
              elevation: 0,
              leading: Container(),
              backgroundColor: Colors.transparent,
              actions: widget.isAlbum ?? true
                  ? [
                      IconButton(
                        icon: Text('相册'),
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
          Positioned(
            bottom: MediaQuery.of(context).size.height * 0.2,
            left: 0,
            right: 0,
            child: Center(
              child: GestureDetector(
                child: Text(_status ? '打开手电筒' : '关闭手电筒', style: TextStyle(color: Colors.white)),
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
