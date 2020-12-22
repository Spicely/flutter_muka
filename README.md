# muka

Flutter样式组件

## 引入方式

```
    muka:
      git: https://github.com/Spicely/flutter-muka.git


    /// 在pubspec.yaml中增加
    dev_dependencies:
      flutter_test:
        sdk: flutter
  +   json_serializable:
```

#### Ios `Info.plist`

```
    <key>NSFaceIDUsageDescription</key>
    <string>Why is my app authenticating using face id?</string>
```

#### GridBox、GridItem 网格组件
```
    GridBox(
        padding: EdgeInsets.symmetric(horizontal: 10),
        children: [
          GridItem(
            image: CachedNetworkImage(
              width: 50,
              height: 50,
              imageUrl: 'https://img.muka.site/icon/activity.png',
            ),
            text: Text('帮助'),
          ),
          GridItem(
            image: CachedNetworkImage(
              width: 50,
              height: 50,
              imageUrl: 'https://img.muka.site/icon/activity.png',
            ),
            text: Text('帮助'),
          ),
          GridItem(
            image: CachedNetworkImage(
              width: 50,
              height: 50,
              imageUrl: 'https://img.muka.site/icon/activity.png',
            ),
            text: Text('帮助'),
          ),
        ],
      )
```

#### Empty
```
    /// 全局样式
    Empty.GLOBAL_EMPTY_DATA_URL = 'assets/images/empty.png';
    Empty.GLOBAL_NOT_NETWORK_URL = 'assets/images/empty.png';
    Empty.WIDTH = 240;

    Empty(
        initLoad: _getData,
        /// 覆盖全局
        empty: Text('无数据'),
        /// 覆盖全局
        network: Text('无网络'),
        child: Text('111'),
    );
```

#### PageInit
```
    /// 监听返回按键 点击空白处关闭键盘
    PageInit(
        exitLabel: '再按一次推辞'
        child: Text('111)
    );
```

#### 指纹验证 `已删除`

```
    // 修改 MainActivity.kt

    修改为 
    import androidx.annotation.NonNull
    import io.flutter.embedding.engine.FlutterEngine
    import io.flutter.embedding.android.FlutterFragmentActivity
    import io.flutter.plugins.GeneratedPluginRegistrant

    class MainActivity : FlutterFragmentActivity() {
        override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
            GeneratedPluginRegistrant.registerWith(flutterEngine)
        }
    }
```

#### AppUpdate
```
    /// 检测更新 请求返回数据是固定的
    AppUpdate.checkUpdate(
      context,
      url: '/home/app',
      appId: 'io.cordova.maixiaobu',
    );

    /// 要求返回的数据格式
    {
      'data': {
        /// 是否更新
        bool hasUpdate;

        /// 是否强制更新
        bool isIgnorable;

        /// 是否跳转appStore
        bool isAppStore;

        /// app版本号
        String versionCode;

        /// app大小
        String apkSize;

        /// 下载地址
        String downloadUrl;

        /// 更新内容
        String updateContent;
      },
      'status': 200,
      'msg': '请求成功'
    }
```

#### ListItem
```
  /// 列表组件
  ListItem(
    height: 30, 
    title: Text("左标题"),
    value: Text("右值"),
    showArrow: true,
    fieldType: FieldType.TITLE,
  );
```
#### CustomStepper
```
  /// 步骤条组件 和flutter的使用方式基本一致
  CustomStepper(
      type: CustomStepperType.horizontal,
      currentStep: 0,
      lineHeight: 10.0,
      lineMargin: EdgeInsets.all(0),
      steps: <CustomStep>[
        CustomStep(
          title: Text('身份信息'),
          content: Text('显示内容'),
          // state: CustomStepState.complete,
          isActive: true,
        ),
        CustomStep(
          title: Text('个人资料'),
          content: Container(),
        ),
      ],
    );
```

#### StartUp
```
  StartUp(
    timer: StartupTimerType.bottom,
    child: Image.asset(
      'assets/images/3.png',
      width: double.infinity,
      fit: BoxFit.cover,
    ),
    logo: Center(
      child: Image.asset(
        'assets/images/btm.jpg',
        width: 140,
      ),
    ),
    onTimeEnd: () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (BuildContext context) => Welcome()),
        // (route) => false,
      );
    },
  )
```

#### DialogUtils

```
  /// 弹出签名 并获取签名
  Uint8List? image = await DialogUtils.signature(context);

  final tempDir = await getTemporaryDirectory();
  final file = await File('${tempDir.path}/image.png').create();
  file.writeAsBytesSync(image!);
```