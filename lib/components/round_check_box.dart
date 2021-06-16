part of flutter_muka;

class RoundCheckBox extends StatefulWidget {
  const RoundCheckBox({
    Key? key,
    required this.isChecked,
    this.checkedWidget,
    this.uncheckedWidget,
    this.checkedColor,
    this.uncheckedColor,
    this.borderColor,
    this.size,
    this.animationDuration,
    required this.onTap,
  }) : super(key: key);

  ///Define wether the checkbox is marked or not
  final bool isChecked;

  ///Define the widget that is shown when Widgets is checked
  final Widget? checkedWidget;

  ///Define the widget that is shown when Widgets is unchecked
  final Widget? uncheckedWidget;

  ///Define the color that is shown when Widgets is checked
  final Color? checkedColor;

  ///Define the color that is shown when Widgets is unchecked
  final Color? uncheckedColor;

  ///Define the border of the widget
  final Color? borderColor;

  ///Define the size of the checkbox
  final double? size;

  ///Define Function that os executed when user tap on checkbox
  final Function(bool)? onTap;

  ///Define the duration of the animation. If any
  final Duration? animationDuration;

  @override
  _RoundCheckBoxState createState() => _RoundCheckBoxState();
}

class _RoundCheckBoxState extends State<RoundCheckBox> {
  late Duration animationDuration;
  double? size;
  Widget? checkedWidget;
  Widget? uncheckedWidget;
  Color? checkedColor;
  Color? uncheckedColor;
  late Color borderColor;

  @override
  void initState() {
    animationDuration = widget.animationDuration ?? Duration(milliseconds: 500);
    size = widget.size ?? 40.0;
    checkedColor = widget.checkedColor ?? Colors.green;
    borderColor = widget.borderColor ?? Colors.grey;
    checkedWidget = widget.checkedWidget ?? Icon(Icons.check, color: Colors.white);
    uncheckedWidget = widget.uncheckedWidget ?? const SizedBox.shrink();
    super.initState();
  }

  @override
  void didUpdateWidget(RoundCheckBox oldWidget) {
    uncheckedColor = widget.uncheckedColor ?? Theme.of(context).scaffoldBackgroundColor;
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.onTap?.call(!widget.isChecked);
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(size! / 2),
        child: AnimatedContainer(
          duration: animationDuration,
          height: size,
          width: size,
          decoration: BoxDecoration(
            color: widget.isChecked ? checkedColor : uncheckedColor,
            border: Border.all(
              color: borderColor,
            ),
            borderRadius: BorderRadius.circular(size! / 2),
          ),
          child: widget.isChecked ? checkedWidget : uncheckedWidget,
        ),
      ),
    );
  }
}
