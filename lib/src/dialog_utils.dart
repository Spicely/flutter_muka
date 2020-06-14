part of '../muka.dart';

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
                  child: content(context, state),
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
  }) {
    showDialog(
      context: context,
      builder: (_) => WillPopScope(
        onWillPop: () {
          return Future.value(true);
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
