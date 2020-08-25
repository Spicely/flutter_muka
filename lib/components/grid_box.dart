part of muka;

/////////////////////////////////////////////////////////////////////////
//// All rights reserved.
//// author: Spicely
//// Summary: 用于展示GridItem组件
//// Date: 2020年08月25日 22:49:26 Tuesday
//////////////////////////////////////////////////////////////////////////

class GridBox extends StatefulWidget {
  final List<Widget> children;

  final int crossAxisCount;

  final double mainAxisSpacing;

  final double crossAxisSpacing;

  final double childAspectRatio;

  final EdgeInsetsGeometry padding;

  const GridBox({
    Key key,
    this.children = const [],
    this.crossAxisCount = 4,
    this.mainAxisSpacing = 0,
    this.crossAxisSpacing = 5.0,
    this.childAspectRatio = 1.0,
    this.padding = const EdgeInsets.all(0),
  }) : super(key: key);
  @override
  _GridBoxState createState() => _GridBoxState();
}

class _GridBoxState extends State<GridBox> {
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: widget.padding,
      itemCount: widget.children.length,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: widget.crossAxisCount,
        mainAxisSpacing: widget.mainAxisSpacing,
        crossAxisSpacing: widget.crossAxisSpacing,
        childAspectRatio: widget.childAspectRatio,
      ),
      itemBuilder: (BuildContext context, int index) {
        return widget.children[index];
      },
    );
  }
}
