part of '../muka.dart';

/////////////////////////////////////////////////////////////////////////
//// All rights reserved.
//// author: Spicely
//// Summary: App检测更新
//// Date: 2020年05月27日 17:13:28 Wednesday
//////////////////////////////////////////////////////////////////////////

class AppUpdate {
  static checkUpdate(
    BuildContext context, {
    @required String url,
    @required Image updateImage,
    @required String appId,
    Color progressColor,
    Animation<Color> progressValueColor,
    double progressHeight = 8,
    bool verify = false,
  }) async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String version = packageInfo.version;
    if (verify) {
      try {
        Response res = await Dio().post('https://api.muka.site/app/verify', data: {'appId': packageInfo.packageName});
        HttpRes.verify(context, res.data, callback: (dynamic data) {
          if (!data['status']) {
            SystemChannels.platform.invokeMethod('SystemNavigator.pop');
          }
        });
      } catch (e) {
        print('服务器异常-----获取失败');
      }
    }
    Map<dynamic, dynamic> res = await HttpUtils.request(url, data: {
      'version': version,
      'platform': Utils.platform,
    });
    HttpRes.verify(
      context,
      res,
      callback: (dynamic data) {
        Update val = Update.fromJson(data);
        if (val.hasUpdate) {
          bool hasDown = false;
          double progress = 0;
          bool hasState = true;
          DialogUtils.showInfo(
            context,
            color: Colors.transparent,
            height: 490,
            elevation: 0,
            showClose: !val.isIgnorable,
            willPop: !val.isIgnorable,
            close: val.isIgnorable
                ? null
                : Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: Column(
                      children: <Widget>[
                        Container(height: 40, width: 1, color: Colors.white),
                        GestureDetector(
                          onTap: () {
                            hasState = false;
                            Navigator.pop(context);
                          },
                          child: Icon(Icons.highlight_off, color: Colors.white, size: 30),
                        ),
                      ],
                    ),
                  ),
            content: (context, state) {
              return Column(
                children: <Widget>[
                  updateImage,
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(bottom: Radius.circular(10))),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text('是否更新到${val.versionCode}版本?'),
                        Padding(
                          padding: EdgeInsets.only(top: 10),
                          child: Text(
                            '新版本大小：${val.apkSize}',
                            style: TextStyle(color: Colors.black54),
                          ),
                        ),
                        Container(
                          height: 110,
                          padding: EdgeInsets.only(top: 20),
                          child: ListView(
                            padding: EdgeInsets.all(0),
                            children: <Widget>[
                              Html(
                                data: val.updateContent,
                              )
                            ],
                          ),
                        ),
                        Container(
                          width: double.infinity,
                          margin: EdgeInsets.only(top: 10),
                          height: 45,
                          child: hasDown
                              ? Stack(
                                  children: <Widget>[
                                    Container(
                                      constraints: BoxConstraints(
                                        maxHeight: progressHeight,
                                      ),
                                      child: LinearProgressIndicator(
                                        value: progress,
                                        backgroundColor: progressColor,
                                        valueColor: progressValueColor,
                                      ),
                                    ),
                                    Positioned(
                                      top: 20,
                                      right: 0,
                                      child: Container(
                                        color: Colors.white,
                                        child: Text(
                                          '${(progress * 100).toStringAsFixed(1)}%',
                                          style: TextStyle(color: progressValueColor ?? Theme.of(context).primaryColor),
                                        ),
                                      ),
                                    )
                                  ],
                                )
                              : RaisedButton(
                                  elevation: 0,
                                  color: Theme.of(context).primaryColor,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(22.0))),
                                  child: Text('立即更新', style: TextStyle(color: Colors.white, fontSize: 15)),
                                  onPressed: () async {
                                    if (val.isAppStore) {
                                      InstallPlugin.gotoAppStore(val.downloadUrl);
                                    } else {
                                      hasDown = true;
                                      Directory storageDir = await getExternalStorageDirectory();
                                      String storagePath = storageDir.path;
                                      File file = File('$storagePath/${packageInfo.appName}v${val.versionCode}${Platform.isAndroid ? '.apk' : '.ipa'}');
                                      if (!file.existsSync()) {
                                        file.createSync();
                                      }
                                      state(() {});
                                      Response response = await Dio().get(
                                        val.downloadUrl,
                                        onReceiveProgress: (int received, int total) {
                                          if (total != -1 && hasState) {
                                            progress = received / total;
                                            state(() {});
                                          }
                                        },
                                        options: Options(
                                          responseType: ResponseType.bytes,
                                          followRedirects: false,
                                        ),
                                      );
                                      file.writeAsBytesSync(response.data);
                                      String apkFilePath = file.path;
                                      if (apkFilePath.isEmpty) {
                                        print('make sure the apk file is set');
                                        return;
                                      }
                                      bool granted = await Permission.storage.request().isGranted;
                                      if (granted) {
                                        await InstallPlugin.installApk(apkFilePath, appId);
                                      }
                                    }
                                  },
                                ),
                        ),
                      ],
                    ),
                  )
                ],
              );
            },
          );
        }
      },
    );
  }
}

