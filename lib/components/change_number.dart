part of flutter_muka;

typedef void ChangeNumberCallBack(int value);

enum ChangeNumberType {
  btn,
  outline,
}

/// 按钮参数
class ChangeNumberButtonConfig {
  /// 按钮字体大小
  final double size;

  /// 按钮颜色
  final Color color;

  /// 按钮背景颜色
  final Color backgroundColor;

  /// 不可用时按钮颜色
  final Color disabledColor;

  /// 不可用时背景颜色
  final Color disabledBackgroundColor;

  const ChangeNumberButtonConfig({
    this.size = 20,
    this.color = Colors.black,
    this.backgroundColor = Colors.black12,
    this.disabledColor = Colors.black26,
    this.disabledBackgroundColor = Colors.black12,
  });
}

class ChangeNumber extends StatefulWidget {
  /// 最小值
  final int? min;

  /// 最大值
  final int? max;

  /// 每次减多少/加多少
  final int step;

  /// 减按钮配置 [reduce]存在时无效
  final ChangeNumberButtonConfig reduceConfig;

  /// 减组件
  final Widget? reduce;

  /// 加按钮配置 [plus]存在时无效
  final ChangeNumberButtonConfig plusConfig;

  /// 加组件
  final Widget? plus;

  /// 显示值
  final int value;

  final ChangeNumberCallBack onChanged;

  final ChangeNumberType type;

  final double? width;

  final double? height;

  /// 边框颜色
  final Color? outlineBorderColor;

  const ChangeNumber({
    Key? key,
    this.min,
    this.max,
    this.reduceConfig = const ChangeNumberButtonConfig(),
    this.plusConfig = const ChangeNumberButtonConfig(),
    this.step = 1,
    this.plus,
    this.reduce,
    this.width,
    this.height,
    required this.value,
    required this.onChanged,
    this.outlineBorderColor,
    this.type = ChangeNumberType.btn,
  }) : super(key: key);

  @override
  _ChangeNumberState createState() => _ChangeNumberState();
}

class _ChangeNumberState extends State<ChangeNumber> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.value.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: widget.height,
      padding: EdgeInsets.symmetric(horizontal: widget.type == ChangeNumberType.outline ? 8 : 0),
      decoration: widget.type == ChangeNumberType.outline
          ? BoxDecoration(
              border: Border.all(color: widget.outlineBorderColor ?? Theme.of(context).dividerColor),
              borderRadius: BorderRadius.circular(40),
            )
          : null,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () {
              if (widget.min != null && widget.value == widget.min) {
                return;
              }
              int _v = widget.value - widget.step;
              if (widget.min != null) {
                if (_v < widget.min!) {
                  _v = widget.min!;
                }
              }
              _controller.text = _v.toString();
              widget.onChanged(_v);
            },
            child: widget.reduce ??
                Container(
                  height: widget.reduceConfig.size,
                  width: widget.reduceConfig.size,
                  decoration: BoxDecoration(
                    color: widget.type == ChangeNumberType.outline
                        ? null
                        : widget.min != null
                            ? widget.min == widget.value
                                ? widget.reduceConfig.disabledBackgroundColor
                                : widget.reduceConfig.backgroundColor
                            : widget.reduceConfig.backgroundColor,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Icon(
                    Icons.remove,
                    size: widget.reduceConfig.size * 0.6,
                    color: widget.min != null
                        ? widget.min == widget.value
                            ? widget.reduceConfig.disabledColor
                            : widget.reduceConfig.color
                        : widget.reduceConfig.color,
                  ),
                ),
          ),
          Expanded(
            child: Center(
              child: TextField(
                controller: _controller,
                textAlign: TextAlign.center,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  isCollapsed: true,
                ),
                onChanged: (val) {
                  try {
                    int _v = int.parse(val);
                    if (widget.max != null) {
                      if (_v > widget.max!) {
                        _v = widget.max!;
                      }
                    }
                    if (widget.min != null) {
                      if (_v < widget.min!) {
                        _v = widget.min!;
                      }
                    }
                    _controller.text = _v.toString();
                    widget.onChanged(_v);
                  } catch (e) {
                    _controller.text = widget.value.toString();
                  }
                },
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              if (widget.min != null && widget.value == widget.max) {
                return;
              }
              int _v = widget.value + widget.step;
              if (widget.max != null) {
                if (_v > widget.max!) {
                  _v = widget.max!;
                }
              }
              _controller.text = _v.toString();
              widget.onChanged(_v);
            },
            child: widget.plus ??
                Container(
                  height: widget.plusConfig.size,
                  width: widget.plusConfig.size,
                  decoration: BoxDecoration(
                    color: widget.type == ChangeNumberType.outline
                        ? null
                        : widget.max != null
                            ? widget.max == widget.value
                                ? widget.plusConfig.disabledBackgroundColor
                                : widget.plusConfig.backgroundColor
                            : widget.plusConfig.backgroundColor,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Icon(
                    Icons.add,
                    size: widget.plusConfig.size * 0.6,
                    color: widget.max != null
                        ? widget.max == widget.value
                            ? widget.plusConfig.disabledColor
                            : widget.plusConfig.color
                        : widget.plusConfig.color,
                  ),
                ),
          ),
        ],
      ),
    );
  }
}
