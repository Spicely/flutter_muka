part of muka;

/////////////////////////////////////////////////////////////////////////
//// All rights reserved.
//// author: Spicely
//// Summary: 网格列表
//// Date: 2020年08月25日 21:16:56 Tuesday
//////////////////////////////////////////////////////////////////////////

class GridItem extends StatefulWidget {
  final double width;

  /// 网格图片
  final Widget image;

  /// 文字
  final Widget text;

  /// 文字间距
  final EdgeInsetsGeometry textMargin;

  final EdgeInsetsGeometry padding;

  final void Function() onTap;

  const GridItem({
    Key key,
    this.width,
    this.image,
    this.text,
    this.textMargin = const EdgeInsets.only(top: 5),
    this.padding = const EdgeInsets.all(0),
    this.onTap,
  }) : super(key: key);

  @override
  _GridItemState createState() => _GridItemState();
}

class _GridItemState extends State<GridItem> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        width: widget.width ?? double.infinity,
        child: Column(
          children: [
            widget.image ?? Container(),
            Container(
              margin: widget.textMargin,
              child: widget.text ?? Container(),
            ),
          ],
        ),
      ),
    );
  }
}
