part of flutter_muka;

/////////////////////////////////////////////////////////////////////////
//// All rights reserved.
//// author: Spicely
//// Summary: 网格列表
//// Date: 2020年08月25日 21:16:56 Tuesday
//////////////////////////////////////////////////////////////////////////

class GridItem extends StatelessWidget {
  final double? width;

  final double? height;

  /// 网格图片
  final Widget? image;

  /// 文字
  final Widget? label;

  /// 文字间距
  final EdgeInsetsGeometry textMargin;

  final EdgeInsetsGeometry padding;

  final void Function()? onTap;

  final CrossAxisAlignment crossAxisAlignment;

  final BoxDecoration? decoration;

  const GridItem({
    Key? key,
    this.width,
    this.height,
    this.image,
    this.label,
    this.textMargin = const EdgeInsets.only(top: 5),
    this.padding = const EdgeInsets.all(0),
    this.onTap,
    this.decoration,
    this.crossAxisAlignment = CrossAxisAlignment.center,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: padding,
        color: decoration != null ? null : Colors.transparent,
        width: width ?? double.infinity,
        decoration: decoration,
        height: height,
        child: Column(
          crossAxisAlignment: crossAxisAlignment,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            image ?? Container(),
            Container(
              margin: textMargin,
              child: label ?? Container(),
            ),
          ],
        ),
      ),
    );
  }
}
