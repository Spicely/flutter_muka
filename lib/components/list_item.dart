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

class ListItem extends StatelessWidget {
  /// 是否显示箭头
  final bool showArrow;

  /// 高度
  final double height;

  final EdgeInsetsGeometry contentPadding;

  final Widget? title;

  final Widget? leading;

  final Widget? value;

  final EdgeInsetsGeometry? margin;

  final Color? color;

  final AlignmentGeometry valueAlignment;

  /// 当showArrow == true时 无效
  final Widget? icon;

  final Color? iconColor;

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

  final EdgeInsets leadingEdgeInsets;

  final DecorationImage? image;

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
    this.leading,
    this.leadingEdgeInsets: const EdgeInsets.only(right: 10),
    this.image,
    this.iconColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: onLongPress,
      onTap: onTap,
      child: Column(
        children: [
          Container(
            height: showDivider ? height + 0.1 : height,
            margin: margin,
            padding: contentPadding,
            decoration: BoxDecoration(
              color: color ?? Colors.transparent,
              borderRadius: borderRadius,
              boxShadow: boxShadow,
              image: image,
            ),
            child: Row(
              children: <Widget>[
                if (leading != null) Padding(padding: leadingEdgeInsets, child: leading),
                fieldType.index == 0 ? Expanded(child: Container(child: title)) : Container(child: title),
                fieldType.index == 0
                    ? Container(
                        alignment: valueAlignment,
                        child: value ?? Container(),
                      )
                    : Expanded(
                        child: Container(
                          alignment: valueAlignment,
                          child: value ?? Container(),
                        ),
                      ),
                showArrow
                    ? Padding(
                        padding: EdgeInsets.only(left: 10, top: 1.5),
                        child: Center(
                          child: Icon(
                            Icons.arrow_forward_ios,
                            size: 13,
                            color: iconColor ?? Theme.of(context).hintColor.withOpacity(0.2),
                          ),
                        ),
                      )
                    : icon ?? Container()
              ],
            ),
          ),
          showDivider ? Divider(height: 0.11, indent: dividerIndex, endIndent: dividerEndIndex) : Container(),
        ],
      ),
    );
  }
}
