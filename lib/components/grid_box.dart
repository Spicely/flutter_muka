part of flutter_muka;

/////////////////////////////////////////////////////////////////////////
//// All rights reserved.
//// author: Spicely
//// Summary: 用于展示GridItem组件
//// Date: 2020年08月25日 22:49:26 Tuesday
//////////////////////////////////////////////////////////////////////////

class GridBox extends StatelessWidget {
  final List<Widget> children;

  final int crossAxisCount;

  final double mainAxisSpacing;

  final double crossAxisSpacing;

  final double childAspectRatio;

  final EdgeInsetsGeometry padding;

  final EdgeInsetsGeometry margin;

  final Color color;

  final BoxDecoration? decoration;

  final double? height;
  const GridBox({
    Key? key,
    this.children = const [],
    this.crossAxisCount = 4,
    this.mainAxisSpacing = 4,
    this.crossAxisSpacing = 5.0,
    this.childAspectRatio = 1.0,
    this.padding = const EdgeInsets.symmetric(vertical: 10),
    this.decoration,
    this.margin = const EdgeInsets.all(0),
    this.color = Colors.white,
    this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: this.height,
      margin: this.margin,
      padding: this.padding,
      decoration: this.decoration ??
          BoxDecoration(
            borderRadius: BorderRadius.circular(0),
            color: this.color,
          ),
      child: Material(
        child: Ink(
          color: Colors.white,
          child: GridView.builder(
            padding: EdgeInsets.all(0),
            itemCount: this.children.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: this.crossAxisCount,
              mainAxisSpacing: this.mainAxisSpacing,
              crossAxisSpacing: this.crossAxisSpacing,
              childAspectRatio: this.childAspectRatio,
            ),
            itemBuilder: (BuildContext context, int index) {
              return this.children[index];
            },
          ),
        ),
      ),
    );
  }
}
