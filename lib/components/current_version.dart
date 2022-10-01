/*
 * Summary: 获取当前版本
 * Created Date: 2022-08-24 01:03:48
 * Author: Spicely
 * -----
 * Last Modified: 2022-10-02 00:35:08
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

class CurrentVersion extends StatelessWidget {
  final TextStyle? style;

  final MukaFutureLayoutBuilderTheme? config;

  const CurrentVersion({
    Key? key,
    this.style,
    this.config,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureLayoutBuilder<String>(
      config: MukaFutureLayoutBuilderTheme(
        loadingWidget: (context) => Container(),
        errorWidget: (context, _) => Text('1.0.0'),
      ),
      future: _future,
      builder: (version) {
        Container();
        return Text(version, style: this.style);
      },
    );
  }

  Future<String> _future() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.version;
  }
}
