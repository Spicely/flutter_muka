part of flutter_muka;

/////////////////////////////////////////////////////////////////////////
//// All rights reserved.
//// author: Spicely
//// Summary: App检测更新
//// Date: 2020年05月27日 17:13:28 Wednesday
//////////////////////////////////////////////////////////////////////////

bool _status = true;

class AppUpdate {
  static checkUpdate(
    BuildContext context, {
    required String url,
    required String appId,
    Image? updateImage,
    Color? progressColor,
    Animation<Color>? progressValueColor,
    double progressHeight = 8,
    bool verify = false,
    String method = 'POST',
    Map<dynamic, dynamic>? data,
    GestureTapCallback? onNotUpdate,
    ThemeData? themeData,
  }) async {
    if (!_status) return;
    _status = false;
    if (kIsWeb) {
      logger.e('AppUpdate.checkUpdate -> 网页调用此函数无效');
      return;
    }
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String version = packageInfo.version;
    if (verify) {
      try {
        Response res = await Dio().post('https://api.muka.site/app/verify', data: {
          'appId': packageInfo.packageName,
        });
        dynamic body = await HttpRes.verify(context, res.data);
        if (!body['status']) {
          exit(0);
        }
      } catch (e) {
        logger.e(e);
      }
    }
    try {
      Map<String, dynamic> params = {
        'version': version,
        'platform': Utils.platform,
      };
      if (data != null) {
        data.forEach((key, value) {
          params[key] = value;
        });
      }
      Response<dynamic> res = await Dio().request(
        url,
        options: Options(method: method),
        data: method.toUpperCase() != 'GET' ? params : null,
        queryParameters: method.toUpperCase() == 'GET' ? params : null,
      );
      dynamic body = await HttpRes.verify(context, res.data);
      UpgradeModel val = UpgradeModel.fromJson(body);
      if (val.hasUpdate) {
        bool hasDown = false;
        double progress = 0;
        bool hasState = true;
        DialogUtils.showInfo(
          context,
          color: Colors.transparent,
          onWillPop: () {
            _status = true;
          },
          width: MediaQuery.of(context).size.width * 0.8,
          elevation: 0,
          showClose: !val.isIgnorable,
          willPop: !val.isIgnorable,
          close: !val.isIgnorable
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      height: 40,
                      width: 1,
                      color: Colors.white,
                    ),
                    GestureDetector(
                      onTap: () {
                        hasState = false;
                        _status = true;
                        Navigator.pop(context);
                      },
                      child: Icon(Icons.highlight_off, color: Colors.white, size: 30),
                    ),
                  ],
                )
              : null,
          content: (context, state) {
            return Theme(
              data: themeData ?? Theme.of(context),
              child: Column(
                children: <Widget>[
                  updateImage ?? Image.asset('packages/flutter_muka/assets/images/bg_update_top.png'),
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
                                          '${progress.toStringAsFixed(1)}%',
                                          style: TextStyle(color: progressValueColor as Color? ?? Theme.of(context).primaryColor),
                                        ),
                                      ),
                                    )
                                  ],
                                )
                              : ElevatedButton(
                                  style: ButtonStyle(
                                    elevation: MaterialStateProperty.all(0),
                                    shape: MaterialStateProperty.all(
                                      RoundedRectangleBorder(borderRadius: BorderRadius.circular(22.0)),
                                    ),
                                  ),
                                  child: Text('立即更新', style: TextStyle(color: Colors.white, fontSize: 15)),
                                  onPressed: () async {
                                    if (val.isAppStore) {
                                      if (Platform.isIOS) {
                                        await RUpgrade.upgradeFromAppStore(val.downloadUrl);
                                      } else {
                                        await RUpgrade.upgradeFromAndroidStore(AndroidStore.BAIDU);
                                        await RUpgrade.upgradeFromAndroidStore(AndroidStore.COOLAPK);
                                        await RUpgrade.upgradeFromAndroidStore(AndroidStore.GOAPK);
                                        await RUpgrade.upgradeFromAndroidStore(AndroidStore.GOOGLE_PLAY);
                                        await RUpgrade.upgradeFromAndroidStore(AndroidStore.HIAPK);
                                        await RUpgrade.upgradeFromAndroidStore(AndroidStore.HUAWEI);
                                        await RUpgrade.upgradeFromAndroidStore(AndroidStore.QIHOO);
                                        await RUpgrade.upgradeFromAndroidStore(AndroidStore.TENCENT);
                                        await RUpgrade.upgradeFromAndroidStore(AndroidStore.XIAOMI);
                                      }
                                    } else {
                                      hasDown = true;
                                      String _filename = val.downloadUrl.split('/').last;
                                      RUpgrade.stream.listen((DownloadInfo info) async {
                                        if (info.maxLength != -1 && hasState) {
                                          progress = info.percent!;
                                          state(() {});
                                        }
                                        if (info.status == DownloadStatus.STATUS_SUCCESSFUL) {
                                          progress = 100;
                                          state(() {});
                                          bool granted = await Permission.storage.request().isGranted;

                                          if (granted) {
                                            await RUpgrade.install(info.id!);
                                          }
                                        }
                                      });
                                      await RUpgrade.upgrade(val.downloadUrl, fileName: _filename);
                                    }
                                  },
                                ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            );
          },
        );
      } else {
        onNotUpdate?.call();
      }
    } catch (e) {
      logger.e(e);
    }
  }
}
