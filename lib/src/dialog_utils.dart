part of muka;

class DialogUtils {
  static void showMsg({
    @required BuildContext context,
    @required String text,
    VoidCallback onOk,
  }) {
    onOk = onOk ?? () {};
    showDialog(
      context: context,
      builder: (_) => WillPopScope(
        onWillPop: () {
          return Future.value(false);
        },
        child: AlertDialog(
          content: Text(text),
          actions: <Widget>[
            FlatButton(
              child: Text('确认'),
              onPressed: () {
                onOk();
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ),
    );
  }

  static List<DialogShareData> _shareData = [
    DialogShareData.fromJson({"icon": "packages/muka/assets/images/wx.png", "title": "微信好友", "key": "wx"}),
    DialogShareData.fromJson({"icon": "packages/muka/assets/images/wx_friend.png", "title": "朋友圈", "key": "wx_firend"}),
    DialogShareData.fromJson({"icon": "packages/muka/assets/images/qq.png", "title": "QQ", "key": "qq"}),
    DialogShareData.fromJson({"icon": "packages/muka/assets/images/qq_zone.png", "title": "QQ空间", "key": "qq_zone"}),
    DialogShareData.fromJson({"icon": "packages/muka/assets/images/weibo.png", "title": "微博", "key": "weibo"}),
  ];

  static List<DialogShareData> get shareData => _shareData;

  /// 分享
  ///
  /// `title` 标题
  ///
  /// `divider` 标题两边分割西
  ///
  /// `titleStyle` 标题样式
  ///
  /// `data` 渲染列表
  static void share(
    BuildContext context, {
    String title = "分享到",
    bool divider = true,
    TextStyle titleStyle = const TextStyle(color: Colors.black, fontWeight: FontWeight.w700),
    ShapeBorder shape,
    List<DialogShareData> data,
    void Function(String val) onPressed,
  }) {
    showModalBottomSheet<void>(
      context: context,
      shape: shape,
      builder: (BuildContext context) {
        return Container(
          height: 160,
          child: Column(
            children: <Widget>[
              ListItem(
                value: Row(
                  children: <Widget>[
                    Expanded(child: divider ? Divider(height: 0.1) : Container()),
                    Container(
                      width: 120,
                      alignment: Alignment.center,
                      child: Text(title, style: titleStyle),
                    ),
                    Expanded(child: divider ? Divider(height: 0.1) : Container()),
                  ],
                ),
                valueAlignment: Alignment.center,
              ),
              Container(
                height: 90,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      onTap: () {
                        onPressed?.call((data ?? shareData)[index].key);
                      },
                      child: Container(
                        width: 70,
                        height: 70,
                        margin: EdgeInsets.only(left: 10),
                        child: Column(
                          children: <Widget>[
                            Image.asset(
                              (data ?? shareData)[index].icon,
                              width: 60,
                              height: 60,
                            ),
                            Container(
                              padding: EdgeInsets.only(top: 5),
                              child: Text((data ?? shareData)[index].title),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  itemCount: (data ?? _shareData).length,
                ),
              )
            ],
          ),
        );
      },
    );
  }

  static void showInfo(
    BuildContext context, {
    @required Widget Function(BuildContext, void Function(void Function())) content,
    VoidCallback onOk,
    double height = 440,
    double width,
    BorderRadiusGeometry borderRadius = const BorderRadius.all(Radius.circular(10)),
    DecorationImage background,
    Color color,
    double elevation,
    bool willPop = true,
    bool showClose = true,
    Widget close,
  }) {
    onOk = onOk ?? () {};
    showDialog(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (context, state) => WillPopScope(
          onWillPop: () {
            return Future.value(willPop);
          },
          child: AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: borderRadius),
            insetPadding: EdgeInsets.all(0),
            contentPadding: EdgeInsets.all(0),
            elevation: elevation,
            backgroundColor: color,
            content: Stack(
              children: <Widget>[
                Container(
                  height: height,
                  width: width == null ? MediaQuery.of(context).size.width - 60 : width,
                  constraints: BoxConstraints(
                    maxHeight: height,
                    maxWidth: width == null ? MediaQuery.of(context).size.width - 60 : width,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: borderRadius,
                    image: background,
                  ),
                  child: Center(child: content(context, state)),
                ),
                showClose
                    ? close ??
                        Positioned(
                          right: 10,
                          top: 10,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Container(
                              child: Icon(
                                Icons.close,
                                color: Colors.black26,
                              ),
                            ),
                          ),
                        )
                    : Container(height: 0),
              ],
            ),
          ),
        ),
      ),
    );
  }

  static void showTitleMsg({
    @required BuildContext context,
    @required String text,
    String title,
    Widget icon,
    VoidCallback onOk,
    bool showCancel = false,
    VoidCallback onCancel,
  }) {
    onOk = onOk ?? () {};
    onCancel = onCancel ?? () {};
    showDialog(
      context: context,
      builder: (_) => WillPopScope(
        onWillPop: () {
          return Future.value(false);
        },
        child: AlertDialog(
          title: title != null
              ? Row(
                  children: <Widget>[
                    icon ?? Container(),
                    Text(title),
                  ],
                )
              : null,
          content: Text(text),
          actions: <Widget>[
            showCancel
                ? FlatButton(
                    child: Text('取消'),
                    onPressed: () {
                      onCancel();
                      Navigator.of(context).pop();
                    },
                  )
                : Container(),
            FlatButton(
              child: Text('确认'),
              onPressed: () {
                Navigator.of(context).pop();
                onOk();
              },
            ),
          ],
        ),
      ),
    );
  }

  static void showLoading(
    BuildContext context, {
    String text,
    bool willPop = true,
  }) {
    showDialog(
      context: context,
      builder: (_) => WillPopScope(
        onWillPop: () {
          return Future.value(willPop);
        },
        child: AlertDialog(
          content: Container(
            height: 40,
            color: Colors.white,
            child: Row(
              children: <Widget>[
                CircularProgressIndicator(),
                Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: Text(text ?? ''),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
