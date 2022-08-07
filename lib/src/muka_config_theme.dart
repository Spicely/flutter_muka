part of flutter_muka;
/*
 * Summary: flutter_muka 全局配置
 * Created Date: 2022-08-03 11:10:06
 * Author: Spicely
 * -----
 * Last Modified: 2022-08-06 00:18:59
 * Modified By: Spicely
 * -----
 * Copyright (c) 2022 Spicely Inc.
 * 
 * May the force be with you.
 * -----
 * HISTORY:
 * Date      	By	Comments
 */

class MukaBottomSheetLayoutTheme {
  /// layout 背景颜色
  final Color bgColor;

  final EdgeInsets padding;

  /// layout 圆角
  final BorderRadiusGeometry? borderRadius;

  final Gradient? gradient;

  final DecorationImage? image;

  final double barHeight;

  final double barWidth;

  /// 拖拽栏颜色
  final Color barColor;

  final BorderRadiusGeometry? barBorderRadius;

  final EdgeInsetsGeometry barPadding;

  const MukaBottomSheetLayoutTheme({
    this.bgColor = Colors.white,
    this.padding = const EdgeInsets.symmetric(horizontal: 17),
    this.borderRadius,
    this.gradient,
    this.image,
    this.barHeight = 4,
    this.barWidth = 40,
    this.barColor = Colors.grey,
    this.barBorderRadius,
    this.barPadding = const EdgeInsets.symmetric(vertical: 10),
  });
}

class MukaConfigTheme {
  Widget emptyWidget() => SizedBox(child: Text('暂无数据'));

  /// bottomSheet 定制框 参数
  MukaBottomSheetLayoutTheme bottomSheetLayoutTheme = MukaBottomSheetLayoutTheme();
}

class MukaConfig {
  static MukaConfigTheme config = MukaConfigTheme();
}
