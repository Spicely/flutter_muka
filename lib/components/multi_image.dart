part of flutter_muka;

class MultiImage extends StatelessWidget {
  /// 数据
  final List<dynamic> data;

  /// 最大数量
  final int? maxCount;

  /// 水平间距
  final double crossAxisSpacing;

  /// 垂直间距
  final double mainAxisSpacing;

  /// 每列数量
  final int crossAxisCount;

  final BoxBorder? border;

  const MultiImage(
      {Key? key,
      required this.data,
      this.maxCount,
      this.crossAxisSpacing = 5,
      this.mainAxisSpacing = 5,
      this.crossAxisCount = 3,
      this.border})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 800,
      child: GridView.builder(
        shrinkWrap: true,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          crossAxisSpacing: crossAxisSpacing, //水平间距
          mainAxisSpacing: mainAxisSpacing, //垂直间距
          childAspectRatio: 1.0,
        ),
        physics: NeverScrollableScrollPhysics(),
        padding: EdgeInsets.all(5), //GridView内边距
        itemCount: data.length == 0 ? 1 : data.length,
        itemBuilder: (context, index) {
          if (data.length == 0) {
            return Container(
              decoration: BoxDecoration(
                border: border ?? Border.all(style: BorderStyle.solid, color: Theme.of(context).dividerColor),
              ),
              child: Icon(Icons.add, color: Theme.of(context).dividerColor),
            );
          }
          return Container(
            decoration: BoxDecoration(
              border: border ?? Border.all(style: BorderStyle.solid, color: Theme.of(context).dividerColor),
            ),
          );
        },
      ),
    );
  }
}


// class MultiImage extends StatefulWidget {
//   /// 数据
//   final List<dynamic> data;

//   /// 最大数量
//   final int? maxCount;

//   /// 水平间距
//   final double crossAxisSpacing;

//   /// 垂直间距
//   final double mainAxisSpacing;

//   /// 每列数量
//   final int crossAxisCount;

//   const MultiImage({
//     Key? key,
//     required this.data,
//     this.maxCount,
//     this.crossAxisSpacing = 5,
//     this.mainAxisSpacing = 5,
//     this.crossAxisCount = 3,
//   }) : super(key: key);

//   @override
//   _MultiImageState createState() => _MultiImageState();
// }

// class _MultiImageState extends State<MultiImage> {
//   @override
//   Widget build(BuildContext context) {

// }
