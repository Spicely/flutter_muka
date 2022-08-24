/*
 * Summary: 自动缓存
 * Created Date: 2022-06-16 23:41:08
 * Author: Spicely
 * -----
 * Last Modified: 2022-08-24 00:42:25
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

class AutoKeep extends StatefulWidget {
  final Widget child;
  const AutoKeep({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  State<AutoKeep> createState() => _AutoKeepState();
}

class _AutoKeepState extends State<AutoKeep> with AutomaticKeepAliveClientMixin<AutoKeep> {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.child;
  }

  @override
  bool get wantKeepAlive => true;
}
