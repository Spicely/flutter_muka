# muka

Flutter样式组件

## 引入方式

```
    muka:
      git: https://github.com/Spicely/flutter-muka.git
```

#### Android `AndoridManifest.xml`
```
    <!--指纹验证权限-->
    <uses-permission android:name="android.permission.USE_FINGERPRINT"/>
```

#### Ios `Info.plist`

```
    <key>NSFaceIDUsageDescription</key>
    <string>Why is my app authenticating using face id?</string>
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

#### 指纹验证

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