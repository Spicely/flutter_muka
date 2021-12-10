part of flutter_muka;

/////////////////////////////////////////////////////////////////////////
//// All rights reserved.
//// author: Spicely
//// Summary: 网格列表
//// Date: 2020年08月25日 21:16:56 Tuesday
//////////////////////////////////////////////////////////////////////////

class GridItem extends StatelessWidget {
  final double? width;

  /// 网格图片
  final Widget? image;

  /// 文字
  final Widget? label;

  /// 文字间距
  final EdgeInsetsGeometry textMargin;

  final EdgeInsetsGeometry padding;

  final void Function()? onTap;

  final CrossAxisAlignment crossAxisAlignment;

  const GridItem({
    Key? key,
    this.width,
    this.image,
    this.label,
    this.textMargin = const EdgeInsets.only(top: 5),
    this.padding = const EdgeInsets.all(0),
    this.onTap,
    this.crossAxisAlignment = CrossAxisAlignment.center,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: this.onTap,
      child: Container(
        width: this.width ?? double.infinity,
        child: Column(
          crossAxisAlignment: this.crossAxisAlignment,
          children: [
            this.image ?? Container(),
            Container(
              margin: this.textMargin,
              child: this.label ?? Container(),
            ),
          ],
        ),
      ),
    );
  }
}
