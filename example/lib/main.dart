import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_muka/flutter_muka.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  HttpUtils.DEBUG = true;
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.red,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({
    Key? key,
    required this.title,
  }) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _val = 1;

  int _val1 = 1;

  MultiImageController _multiImageController = MultiImageController();

  ImagePicker _picker = ImagePicker();

  CodeTimeController _controller1 = CodeTimeController();

  CodeTimeController _controller2 = CodeTimeController();

  ITextEditingController _textEditingController = ITextEditingController(text: '');

  VirtualKeyboardController _virtualKeyboardController = VirtualKeyboardController();

  FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        _virtualKeyboardController.showKeybord(_textEditingController.text);
      } else {
        _virtualKeyboardController.hideKeybord();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: VirtualKeyboard(
        controller: _virtualKeyboardController,
        onChanged: (val) {
          _textEditingController.text = val;
        },
        child: PageInit(
          child: ListView(
            children: [
              ListItem(
                title: Text('ChangeNumber'),
                color: Colors.white,
                showDivider: true,
                dividerIndex: 15,
                dividerEndIndex: 15,
                value: ChangeNumber(
                  width: 80,
                  value: _val,
                  max: 10,
                  min: 1,
                  step: 2,
                  onChanged: (val) {
                    setState(() {
                      _val = val;
                    });
                  },
                ),
              ),
              Container(
                color: Colors.red,
                child: DashboardProgress(
                  height: 200,
                  value: 60.0,
                  child: Center(
                    child: Text('111'),
                  ),
                ),
              ),
              ListItem(
                showDivider: true,
                dividerIndex: 15,
                dividerEndIndex: 15,
                color: Colors.white,
                title: Text('最大10 最小1 每次进度2 当前值$_val'),
              ),
              ListItem(
                title: Text('ChangeNumber'),
                showDivider: true,
                dividerIndex: 15,
                dividerEndIndex: 15,
                color: Colors.white,
                value: ChangeNumber(
                  type: ChangeNumberType.outline,
                  width: 120,
                  value: _val1,
                  onChanged: (val) {
                    setState(() {
                      _val1 = val;
                    });
                  },
                ),
              ),
              ListItem(
                showDivider: true,
                dividerIndex: 15,
                dividerEndIndex: 15,
                color: Colors.white,
                title: Text('无限制 当前值$_val1'),
              ),
              ListItem(
                title: Text('扫描二维码'),
                color: Colors.white,
                showArrow: true,
                showDivider: true,
                onTap: () {
                  FocusScope.of(context).requestFocus(FocusNode());
                  Future.delayed(Duration(seconds: 1), () async {
                    await [Permission.camera].request();
                    if (await Permission.camera.isGranted) {
                      String? data = await Utils.openBarcode(context, title: '');
                      print(data);
                    } else {
                      // OpenSettings.openLocationSourceSetting();
                      return;
                    }
                  });
                },
              ),
              ListItem(
                title: Text('CodeTime'),
                showDivider: true,
                dividerIndex: 15,
                dividerEndIndex: 15,
                color: Colors.white,
                value: CodeTime(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  hasBorder: true,
                  controller: _controller1,
                  onTap: () async {
                    _controller1.start((handle) {
                      handle.reject();
                    });
                  },
                ),
              ),
              ListItem(
                title: Text('CodeTime'),
                showDivider: true,
                dividerIndex: 15,
                dividerEndIndex: 15,
                color: Colors.white,
                fieldType: FieldType.title,
                value: Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(right: 10),
                      child: ElevatedButton(
                        onPressed: () {
                          _controller2.reset();
                        },
                        child: Text('重置'),
                      ),
                    ),
                    CodeTime(
                      borderRadius: 20,
                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      hasBorder: true,
                      controller: _controller2,
                      label: 'Get verification code',
                      endLabel: 'Reload code',
                      render: (int time) => 'Reload code $time s',
                      onTap: () async {
                        _controller2.start((handle) {
                          handle.resolve();
                        });
                      },
                    ),
                  ],
                ),
              ),
              // TextField(),
              ListItem(
                title: Text('检查更新'),
                color: Colors.white,
                showArrow: true,
                showDivider: true,
                onTap: () {
                  AppManage.upgrade(context, url: 'https://api.muka.site/app/upgrade', appId: 'com.example.example');
                  // AppUpdate.checkUpdate(context, url: 'https://api.muka.site/app/upgrade', appId: 'com.example.example');
                },
              ),
              ListItem(
                title: Text('HTTP请求'),
                color: Colors.white,
                showArrow: true,
                showDivider: true,
                onTap: () {
                  try {
                    HttpUtils.request('https://test.uhomeing.com/app/cityRegion/region/成都市',
                        data: {'aa': 'bb'}, method: HttpUtilsMethod.GET);
                  } on DioError catch (e) {
                    // logger.error
                  } catch (e) {
                    // logger.error
                  }
                },
              ),
              ListItem(
                title: Text('虚拟键盘'),
                color: Colors.white,
                showArrow: true,
                value: TextField(
                  focusNode: _focusNode,
                  controller: _textEditingController,
                ),
                showDivider: true,
              ),
              ListItem(
                title: Text('MultiImage'),
                color: Colors.white,
              ),
              MultiImage(
                controller: _multiImageController,
                // edit: false,
                maxLength: 1,
                onAdd: () async {
                  // PickedFile? pickedFile = await _picker.getImage(source: ImageSource.gallery);
                  // if (pickedFile != null) {
                  //   _multiImageController.add(MultiImagePorps(file: File(pickedFile.path)));
                  // }
                  _multiImageController.add(MultiImageProps(url: 'https://img.muka.site/other/bg.jpg'));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
