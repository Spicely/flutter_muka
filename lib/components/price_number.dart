part of flutter_muka;

/////////////////////////////////////////////////////////////////////////
//// All rights reserved.
//// author: Spicely
//// Summary: 金额数字大小组件
//// Date: 2021年02月22日 22:51:00 Monday
//////////////////////////////////////////////////////////////////////////

class PriceNumber extends StatefulWidget {
  /// 值
  final String value;

  /// 小数点大小
  final double decimalSize;

  /// 小数点颜色
  final Color? decimalColor;

  /// 整数大小
  final double intSize;

  /// 整数颜色
  final Color? intColor;

  /// 金额单位
  final String? unit;

  /// 金额单位颜色
  final Color? unitColor;

  /// 整体颜色
  final Color color;

  final FontWeight? fontWeight;

  /// 金额单位大小
  final double unitSize;

  final FontWeight? uintFontWeight;

  final FontWeight? decimalSizeFontWeight;

  const PriceNumber({
    Key? key,
    required this.value,
    this.decimalSize = 10,
    this.decimalColor,
    this.intSize = 16,
    this.intColor,
    this.unit,
    this.unitColor,
    this.unitSize = 16,
    this.color = Colors.red,
    this.fontWeight,
    this.uintFontWeight,
    this.decimalSizeFontWeight,
  }) : super(key: key);

  @override
  _PriceNumberState createState() => _PriceNumberState();
}

class _PriceNumberState extends State<PriceNumber> {
  @override
  Widget build(BuildContext context) {
    List<String?> data = widget.value.split('.');
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: widget.unit,
            style: TextStyle(
                fontSize: widget.unitSize, color: widget.unitColor ?? widget.color, fontWeight: widget.uintFontWeight ?? widget.fontWeight),
          ),
          TextSpan(
            text: data[0] ?? '0',
            style: TextStyle(
              fontSize: widget.intSize,
              color: widget.intColor ?? widget.color,
              fontWeight: widget.fontWeight,
            ),
          ),
          TextSpan(
            text: '.' + (data[1] ?? '.00'),
            style: TextStyle(
              fontSize: widget.decimalSize,
              color: widget.decimalColor ?? widget.color,
              fontWeight: widget.decimalSizeFontWeight ?? widget.fontWeight,
            ),
          ),
        ],
      ),
    );
  }
}
