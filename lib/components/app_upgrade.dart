/*
 * Summary: APP更新检测
 * Created Date: 2022-07-11 10:44:07
 * Author: Spicely
 * -----
 * Last Modified: 2022-09-08 23:16:37
 * Modified By: Spicely
 * -----
 * Copyright (c) 2022 Spicely Inc.
 * 
 * May the force be with you.
 * -----
 * HISTORY:
 * Date      	By	Comments
 */
part of flutter_muka;

class AppManage {
  static bool _open = false;

  static Future<void> upgrade(
    BuildContext context, {
    required String url,
    Image? updateImage,
    bool verify = false,
    String method = 'POST',
    Map<String, dynamic>? data,
    GestureTapCallback? onNotUpdate,
    ThemeData? themeData,
  }) async {
    if (kIsWeb) {
      logger.e('AppManage.upgrade -> 网页调用此函数无效');
      return;
    }
    if (_open) return;
    _open = true;
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String version = packageInfo.version;
    if (verify) {
      try {
        Response res = await Dio().post(
          'https://api.muka.site/app/verify',
          data: {'appId': packageInfo.packageName},
        );

        if (!res.data['data']['status']) {
          exit(0);
        }
      } catch (e) {
        logger.e(e);
      }
    }

    /// 开始检测更新
    try {
      Map<String, dynamic> params = {
        'version': version,
        'platform': Utils.platform,
        'buildNumber': packageInfo.buildNumber,
        'packageName': packageInfo.packageName,
        'appName': packageInfo.appName,
      };
      if (data != null) {
        params.addAll(data);
      }
      Response<dynamic> res = await Dio().request(
        url,
        options: Options(method: method),
        data: method.toUpperCase() != 'GET' ? params : null,
        queryParameters: method.toUpperCase() == 'GET' ? params : null,
      );
      UpgradeModel val = UpgradeModel.fromJson(res.data['data']);
      _open = false;
      if (val.hasUpdate) {
        showDialog(
          context: context,
          barrierDismissible: !val.isIgnorable,
          builder: (context) => AlertDialog(
            backgroundColor: Colors.transparent,
            contentPadding: EdgeInsets.zero,
            elevation: 0,
            content: _UpgradeView(data: val),
          ),
        );
      } else {
        onNotUpdate?.call();
      }
    } catch (e) {
      _open = false;
      logger.e(e);
    }
  }
}

class _UpgradeView extends StatefulWidget {
  final Image? updateImage;

  final ThemeData? themeData;

  final UpgradeModel data;

  const _UpgradeView({
    Key? key,
    required this.data,
    // ignore: unused_element
    this.updateImage,
    // ignore: unused_element
    this.themeData,
  }) : super(key: key);

  @override
  State<_UpgradeView> createState() => __UpgradeViewState();
}

class __UpgradeViewState extends State<_UpgradeView> {
  bool _hasDown = false;

  double _progress = 0.0;

  late SharedPreferences prefs;

  late StreamSubscription<DownloadInfo> subscription;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      prefs = await SharedPreferences.getInstance();
    });
    subscription = RUpgrade.stream.listen((DownloadInfo info) async {
      if (info.maxLength != -1) {
        _progress = info.percent!;
        setState(() {});
      }
      if (info.status == DownloadStatus.STATUS_SUCCESSFUL) {
        _progress = 100;
        setState(() {});
        bool granted = await Permission.storage.request().isGranted;
        if (granted) {
          prefs.setString('flutter_muka_upgrade_code_${info.id!}_version', widget.data.versionCode);
          await RUpgrade.install(info.id!);
          _hasDown = false;
          setState(() {});
        }
      }
    });
  }

  dispose() {
    subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Theme(
        data: widget.themeData ?? Theme.of(context),
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.8,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              widget.updateImage ?? Image.asset('packages/flutter_muka/assets/images/bg_update_top.png'),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(bottom: Radius.circular(10))),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text('是否更新到${widget.data.versionCode}版本?'),
                    Padding(
                      padding: EdgeInsets.only(top: 10),
                      child: Text(
                        '新版本大小：${widget.data.apkSize}',
                        style: TextStyle(color: Colors.black54),
                      ),
                    ),
                    Container(
                      height: 110,
                      padding: EdgeInsets.only(top: 20),
                      child: ListView(
                        physics: const BouncingScrollPhysics(),
                        padding: EdgeInsets.all(0),
                        children: <Widget>[
                          Html(
                            data: widget.data.updateContent,
                          )
                        ],
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      margin: EdgeInsets.only(top: 10),
                      height: 45,
                      child: _hasDown
                          ? Stack(
                              children: <Widget>[
                                Container(
                                  constraints: BoxConstraints(
                                    maxHeight: 10,
                                  ),
                                  child: LinearPercentIndicator(
                                    percent: _progress / 100,
                                    animation: true,
                                    animationDuration: 200,
                                    animateFromLastPercent: true,
                                    barRadius: Radius.circular(5),
                                  ),
                                ),
                                Positioned(
                                  top: 20,
                                  right: 0,
                                  child: Container(
                                    color: Colors.white,
                                    child: Text('${_progress.toStringAsFixed(1)}%'),
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
                                if (widget.data.isAppStore) {
                                  if (Platform.isIOS) {
                                    await RUpgrade.upgradeFromAppStore(widget.data.downloadUrl);
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
                                  int? id = await RUpgrade.getLastUpgradedId();
                                  if (id != null) {
                                    String? ver = prefs.getString('flutter_muka_upgrade_code_${id}_version');
                                    DownloadStatus? status = await RUpgrade.getDownloadStatus(id);
                                    if (status == null) {
                                      downApk();
                                      return;
                                    }
                                    if (status == DownloadStatus.STATUS_SUCCESSFUL) {
                                      /// 判断存储版本和服务器版本是否一致
                                      if (ver != null && ver == widget.data.versionCode) {
                                        await RUpgrade.install(id);
                                        _hasDown = false;
                                        setState(() {});
                                      } else {
                                        /// 不一致，重新下载
                                        downApk();
                                      }
                                    } else {
                                      /// 下载未完成，重新下载
                                      downApk();
                                      return;
                                    }
                                    return;
                                  }
                                  downApk();
                                }
                              },
                            ),
                    ),
                  ],
                ),
              ),
              if (!widget.data.isIgnorable)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      height: 40,
                      width: 1,
                      color: Colors.white,
                    ),
                    GestureDetector(
                      onTap: () {
                        // hasState = false;
                        Navigator.pop(context);
                      },
                      child: Icon(Icons.highlight_off, color: Colors.white, size: 30),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
      onWillPop: () {
        return Future.value(!widget.data.isIgnorable);
      },
    );
  }

  Future<void> downApk() async {
    _hasDown = true;
    _progress = 0;
    setState(() {});
    String _filename = widget.data.downloadUrl.split('/').last;
    await RUpgrade.upgrade(widget.data.downloadUrl, fileName: _filename);
  }
}
