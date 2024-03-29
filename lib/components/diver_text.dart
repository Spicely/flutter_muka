part of flutter_muka;
/*
 * Summary: 文件描述
 * Created Date: 2023-03-27 10:50:29
 * Author: Spicely
 * -----
 * Last Modified: 2023-03-27 10:50:46
 * Modified By: Spicely
 * -----
 * Copyright (c) 2023 Spicely Inc.
 * 
 * May the force be with you.
 * -----
 * HISTORY:
 * Date      	By	Comments
 */

class DividerText extends StatefulWidget {
  final double indent;

  final String text;

  final EdgeInsetsGeometry margin;

  final Color? textColor;

  final double textSize;

  final double dividerHeight;

  final Color? color;

  const DividerText({
    Key? key,
    this.indent = 20,
    this.textColor,
    this.textSize = 14,
    this.margin = const EdgeInsets.symmetric(vertical: 20),
    this.dividerHeight = 0.5,
    this.color,
    required this.text,
  }) : super(key: key);

  @override
  _DividerTextState createState() => _DividerTextState();
}

class _DividerTextState extends State<DividerText> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: widget.margin,
      child: Row(
        children: [
          Expanded(
            child: Divider(
              color: widget.color,
              endIndent: widget.indent,
              thickness: widget.dividerHeight,
              height: widget.dividerHeight,
            ),
          ),
          Text(
            widget.text,
            style: TextStyle(
              color: widget.textColor ?? Theme.of(context).dividerColor,
              fontSize: widget.textSize,
            ),
          ),
          Expanded(
            child: Divider(
              color: widget.color,
              indent: widget.indent,
              thickness: widget.dividerHeight,
              height: widget.dividerHeight,
            ),
          ),
        ],
      ),
    );
  }
}
