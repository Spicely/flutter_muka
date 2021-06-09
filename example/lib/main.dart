import 'package:flutter/material.dart';
import 'package:flutter_muka/flutter_muka.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
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

  CodeTimeController _controller1 = CodeTimeController();

  CodeTimeController _controller2 = CodeTimeController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ListView(
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
          ListItem(
            showDivider: true,
            dividerIndex: 15,
            dividerEndIndex: 15,
            color: Colors.white,
            title: Text('最大10 最小1 每次进度2 当前值$_val'),
          ),
          ListItem(
            title: Text('CodeTime'),
            showDivider: true,
            dividerIndex: 15,
            dividerEndIndex: 15,
            color: Colors.white,
            value: ChangeNumber(
              width: 100,
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
            fieldType: FieldType.TITLE,
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
          ListItem(
            title: Text('扫描二维码'),
            color: Colors.white,
            showArrow: true,
            showDivider: true,
            onTap: () async {
              await [Permission.camera].request();
              if (await Permission.camera.isGranted) {
                String? data = await Utils.openBarcode(context);
                print(data);
              } else {
                // OpenSettings.openLocationSourceSetting();
                return;
              }
            },
          ),
          ListItem(
            title: Text('检查更新'),
            color: Colors.white,
            showArrow: true,
            onTap: () {
              AppUpdate.checkUpdate(context, url: 'https://api.muka.site/app/upgrade', appId: 'com.example.example');
            },
          ),
        ],
      ),
    );
  }
}
