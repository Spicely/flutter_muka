/*
 * Summary: APP更新检测
 * Created Date: 2022-07-11 10:44:07
 * Author: Spicely
 * -----
 * Last Modified: 2022-07-11 18:28:13
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
    required String appId,
    Image? updateImage,
    bool verify = false,
    String method = 'POST',
    Map<String, dynamic>? data,
    GestureTapCallback? onNotUpdate,
    ThemeData? themeData,
  }) async {
    if (kIsWeb) {
      logger.e('AppUpdate.checkUpdate -> 网页调用此函数无效');
      return;
    }
    if (_open) return;
    _open = true;
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String version = packageInfo.version;
    if (verify) {
      try {
        Response res = await Dio().post('https://api.muka.site/app/verify', data: {
          'appId': packageInfo.packageName,
        });

        if (!res.data['data']['status']) {
          exit(0);
        }
      } catch (e) {
        logger.e(e);
      }
    }

    /// 开始检测更新
    // try {
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
        builder: (context) => AlertDialog(
          backgroundColor: Colors.transparent,
          contentPadding: EdgeInsets.zero,
          content: _UpgradeView(data: val),
        ),
      );
    } else {
      onNotUpdate?.call();
    }
    // } catch (e) {
    //   _open = false;
    //   logger.e(e);
    // }
  }
}

class _UpgradeView extends StatefulWidget {
  final Image? updateImage;

  final ThemeData? themeData;

  final UpgradeModel data;

  const _UpgradeView({
    Key? key,
    required this.data,
    this.updateImage,
    this.themeData,
  }) : super(key: key);

  @override
  State<_UpgradeView> createState() => __UpgradeViewState();
}

class __UpgradeViewState extends State<_UpgradeView> {
  @override
  Widget build(BuildContext context) {
    return Theme(
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
                      padding: EdgeInsets.all(0),
                      children: <Widget>[
                        Html(
                          data: widget.data.updateContent,
                        )
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
