/*
 * Summary: 通知对话框
 * Created Date: 2023-03-28 10:29:13
 * Author: Spicely
 * -----
 * Last Modified: 2023-03-28 14:35:36
 * Modified By: Spicely
 * -----
 * Copyright (c) 2023 Spicely Inc.
 * 
 * May the force be with you.
 * -----
 * HISTORY:
 * Date      	By	Comments
 */

part of flutter_muka;

class NoticeDialogTheme {
  final ButtonStyle? cancelBtnStyle;

  final ButtonStyle? confirmBtnStyle;

  final TextStyle? cancelTextStyle;

  final TextStyle? confirmTextStyle;

  final TextStyle titleStyle;

  final TextStyle? contentStyle;

  const NoticeDialogTheme({
    this.cancelBtnStyle,
    this.confirmBtnStyle,
    this.cancelTextStyle = const TextStyle(fontSize: 16, color: Colors.blue),
    this.confirmTextStyle = const TextStyle(fontSize: 16, color: Colors.blue),
    this.titleStyle = const TextStyle(fontSize: 18, color: Colors.black, fontWeight: FontWeight.bold),
    this.contentStyle = const TextStyle(fontSize: 14),
  });
}

class NoticeDialog extends StatelessWidget {
  final String title;

  final String content;

  final String cancelText;

  final String confirmText;

  final NoticeDialogTheme? theme;

  /// 取消点击事件
  final VoidCallback? onCancel;

  /// 确认点击事件
  final VoidCallback? onConfirm;

  const NoticeDialog({
    Key? key,
    required this.title,
    required this.content,
    this.cancelText = '取消',
    this.confirmText = '确认',
    this.theme = const NoticeDialogTheme(),
    this.onCancel,
    this.onConfirm,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ButtonStyle defaultBtnStyle = TextButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Container(
            width: 320,
            color: Colors.white,
            child: Column(
              children: [
                SizedBox(height: 20),
                Text(title, style: theme?.titleStyle),
                SizedBox(height: 10),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text(content, style: theme?.contentStyle, textAlign: TextAlign.center),
                ),
                SizedBox(height: 20),
                Divider(height: 0.1),
                SizedBox(
                  height: 45,
                  child: Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: double.infinity,
                          child: TextButton(
                            onPressed: onCancel ??
                                () {
                                  Navigator.pop(context);
                                },
                            child: Text(cancelText, style: theme?.cancelTextStyle),
                            style: theme?.cancelBtnStyle ?? defaultBtnStyle,
                          ),
                        ),
                      ),
                      Container(
                        height: double.infinity,
                        width: 0.5,
                        color: Theme.of(context).dividerColor,
                      ),
                      Expanded(
                        child: SizedBox(
                          height: double.infinity,
                          child: TextButton(
                            onPressed: onConfirm,
                            child: Text(confirmText, style: theme?.confirmTextStyle),
                            style: theme?.confirmBtnStyle ?? defaultBtnStyle,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
