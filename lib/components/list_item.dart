/////////////////////////////////////////////////////////////////////////
//// All rights reserved.
//// author: Spicely
//// Summary: 组件样式ListItem
//// Date: 2020年05月26日 15:19:53 Tuesday
//////////////////////////////////////////////////////////////////////////
part of flutter_muka;

enum FieldType {
  /// 以title为flex 1
  title,

  /// 以value为flex 1
  value,
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

  final Color? splashColor;

  final EdgeInsetsGeometry? inkPadding;

  final AlignmentGeometry valueAlignment;

  /// 当showArrow == true时 无效
  final Widget? icon;

  final Color? iconColor;

  /// value 点击事件
  final void Function()? onTap;

  final void Function()? onLongPress;

  final void Function()? onTapValue;

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

  final CrossAxisAlignment crossAxisAlignment;

  final MainAxisAlignment mainAxisAlignment;

  ListItem({
    Key? key,
    this.splashColor,
    this.inkPadding,
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
    this.fieldType = FieldType.value,
    this.color,
    this.borderRadius,
    this.boxShadow,
    this.showDivider = false,
    this.dividerIndex = 0,
    this.dividerEndIndex = 0,
    this.leading,
    this.leadingEdgeInsets = const EdgeInsets.only(right: 10),
    this.image,
    this.iconColor,
    this.onTapValue,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.mainAxisAlignment = MainAxisAlignment.start,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      child: Column(
        children: [
          Ink(
            padding: inkPadding,
            decoration: BoxDecoration(
              color: color ?? Colors.transparent,
              borderRadius: borderRadius,
            ),
            child: InkWell(
              splashColor: splashColor ?? Theme.of(context).splashColor,
              onLongPress: onLongPress,
              onTap: onTap,
              child: Container(
                width: double.infinity,
                constraints: BoxConstraints(
                  minHeight: height,
                ),
                padding: contentPadding,
                decoration: BoxDecoration(
                  borderRadius: borderRadius,
                  boxShadow: boxShadow,
                  image: image,
                ),
                child: Row(
                  crossAxisAlignment: crossAxisAlignment,
                  mainAxisAlignment: mainAxisAlignment,
                  children: <Widget>[
                    if (leading != null) Padding(padding: leadingEdgeInsets, child: leading),
                    fieldType == FieldType.title
                        ? Expanded(
                            child: Container(child: title),
                          )
                        : Container(child: title),
                    fieldType == FieldType.value
                        ? Expanded(
                            child: GestureDetector(
                              onTap: onTapValue,
                              child: Container(
                                constraints: BoxConstraints(
                                  minHeight: showDivider ? height + 0.1 : height,
                                ),
                                alignment: valueAlignment,
                                child: value,
                              ),
                            ),
                          )
                        : Container(
                            alignment: valueAlignment,
                            child: value,
                          ),
                    showArrow
                        ? Padding(
                            padding: EdgeInsets.only(left: 5, top: 1.5),
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
            ),
          ),
          showDivider ? Divider(height: 0.1, indent: dividerIndex, endIndent: dividerEndIndex) : Container(),
        ],
      ),
    );
  }
}
