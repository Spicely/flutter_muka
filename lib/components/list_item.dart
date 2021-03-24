/////////////////////////////////////////////////////////////////////////
//// All rights reserved.
//// author: Spicely
//// Summary: 组件样式ListItem
//// Date: 2020年05月26日 15:19:53 Tuesday
//////////////////////////////////////////////////////////////////////////
part of flutter_muka;

enum FieldType {
  /// 以title为flex 1
  TITLE,

  /// 以value为flex 1
  VALUE,
}

class ListItem extends StatefulWidget {
  /// 是否显示箭头
  final bool showArrow;

  /// 高度
  final double height;

  final EdgeInsetsGeometry contentPadding;

  final Widget? title;

  final Widget? value;

  final EdgeInsetsGeometry? margin;

  final Color? color;

  final AlignmentGeometry valueAlignment;

  /// 当showArrow == true时 无效
  final Widget? icon;

  final void Function()? onTap;

  final void Function()? onLongPress;

  final FieldType fieldType;

  final BorderRadiusGeometry? borderRadius;

  final List<BoxShadow>? boxShadow;

  /// 显示分割线
  final bool showDivider;

  /// 分割线左边距离
  final double dividerIndex;

  /// 分割线dk边距离
  final double dividerEndIndex;

  ListItem({
    Key? key,
    this.showArrow = false,
    this.title,
    this.onTap,
    this.onLongPress,
    this.value,
    this.height = 50.0,
    this.contentPadding = const EdgeInsets.symmetric(horizontal: 15),
    this.margin = const EdgeInsets.all(0),
    this.valueAlignment = Alignment.centerRight,
    this.icon,
    this.fieldType = FieldType.VALUE,
    this.color,
    this.borderRadius,
    this.boxShadow,
    this.showDivider = false,
    this.dividerIndex = 0,
    this.dividerEndIndex = 0,
  }) : super(key: key);
  @override
  State<StatefulWidget> createState() => _ListItemState();
}

class _ListItemState extends State<ListItem> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: widget.onLongPress,
      onTap: widget.onTap,
      child: Column(
        children: [
          Container(
            height: widget.showDivider ? widget.height + 0.1 : widget.height,
            margin: widget.margin,
            padding: widget.contentPadding,
            decoration: BoxDecoration(
              color: widget.color ?? Colors.transparent,
              borderRadius: widget.borderRadius,
              boxShadow: widget.boxShadow,
            ),
            child: Row(
              children: <Widget>[
                widget.fieldType.index == 0 ? Expanded(child: Container(child: widget.title)) : Container(child: widget.title),
                widget.fieldType.index == 0
                    ? Container(
                        alignment: widget.valueAlignment,
                        child: widget.value ?? Container(),
                      )
                    : Expanded(
                        child: Container(
                          alignment: widget.valueAlignment,
                          child: widget.value ?? Container(),
                        ),
                      ),
                widget.showArrow
                    ? Padding(
                        padding: EdgeInsets.only(left: 10, top: 3),
                        child: Icon(
                          Icons.arrow_forward_ios,
                          size: 13,
                          color: Colors.black38,
                        ),
                      )
                    : widget.icon ?? Container()
              ],
            ),
          ),
          widget.showDivider ? Divider(height: 0.11, indent: widget.dividerIndex, endIndent: widget.dividerEndIndex) : Container(),
        ],
      ),
    );
  }
}
