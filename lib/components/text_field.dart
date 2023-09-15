/////////////////////////////////////////////////////////////////////////
//// All rights reserved.
//// author: Spicely
//// Summary: 组件样式ITextField
//// Date: 2020年05月26日 15:19:53 Tuesday
//////////////////////////////////////////////////////////////////////////
part of flutter_muka;

///自带删除的ITextField
typedef void ITextFieldCallBack(String content);

enum ITextInputType { text, multiline, number, phone, datetime, emailAddress, url, password }

class ITextCalculate {
  final int length;

  final String text;

  ITextCalculate({
    required this.length,
    required this.text,
  });
}

ITextCalculate _calculate(String v, int length) => ITextCalculate(length: v.length, text: v);

class ITextField extends StatefulWidget {
  final ITextInputType keyboardType;

  final int? maxLines;

  final int? minLines;

  final int? maxLength;

  final String? hintText;

  final TextStyle? hintStyle;

  final ITextFieldCallBack? onChanged;

  final ITextFieldCallBack? onSubmitted;

  final GestureTapCallback? onEditingComplete;

  final GestureTapCallback? onTap;

  final AppPrivateCommandCallback? onAppPrivateCommand;

  final Icon? deleteIcon;

  final InputBorder? inputBorder;

  final InputBorder? focusedBorder;

  final InputBorder? enabledBorder;

  final double? suffixIconWidth;

  final Widget? prefixIcon;

  final TextStyle? textStyle;

  final Widget? suffixIcon;

  final TextStyle? labelStyle;

  final TextStyle? errorStyle;

  final bool? digitsOnly;

  final Color? cursorColor;

  final bool? obscureText;

  final EdgeInsetsGeometry? contentPadding;

  final FormFieldValidator<String>? validator;

  final ITextEditingController controller;

  final FocusNode? focusNode;

  /// 显示删除按钮
  final bool showDeleteIcon;

  final String? labelText;

  final int? errorMaxLines;

  final InputBorder? errorBorder;

  final InputBorder? focusedErrorBorder;

  final bool readOnly;

  final TextAlign textAlign;

  final BoxConstraints? prefixIconConstraints;

  /// 显示最大长度
  final bool isCount;

  /// countWidget 分隔符
  final String separator;

  /// countWidget 样式
  final TextStyle? countWidgetStyle;

  /// countWidget 样式
  final TextStyle? countWidgetCountStyle;

  /// countWidget 样式
  final TextStyle? countWidgetLengthStyle;

  /// countWidget 样式
  final TextStyle? countWidgetSeparatorStyle;

  final Alignment countWidgetAlignment;

  final bool autofocus;

  final Color? closeIconColor;

  /// count长度计算方法
  final ITextCalculate Function(String, int length) countCalculate;

  final List<TextInputFormatter>? inputFormatters;

  static TextInputFormatter phoneInputFormatter() {
    return TextInputFormatter.withFunction((oldValue, newValue) {
      String text = newValue.text;
      //获取光标左边的文本
      final positionStr = (text.substring(0, newValue.selection.baseOffset)).replaceAll(RegExp(r"\s+\b|\b\s"), "");
      //计算格式化后的光标位置
      int length = positionStr.length;
      var position = 0;
      if (length <= 3) {
        position = length;
      } else if (length <= 7) {
        // 因为前面的字符串里面加了一个空格
        position = length + 1;
      } else if (length <= 11) {
        // 因为前面的字符串里面加了两个空格
        position = length + 2;
      } else {
        // 号码本身为 11 位数字，因多了两个空格，故为 13
        position = 13;
      }

      //这里格式化整个输入文本
      text = text.replaceAll(RegExp(r"\s+\b|\b\s"), "");
      var string = "";
      for (int i = 0; i < text.length; i++) {
        // 这里第 4 位，与第 8 位，我们用空格填充
        if (i == 3 || i == 7) {
          if (text[i] != ' ') {
            string = '$string ';
          }
        }
        string += text[i];
      }

      return TextEditingValue(
        text: string,
        selection: TextSelection.fromPosition(TextPosition(offset: position, affinity: TextAffinity.upstream)),
      );
    });
  }

  static TextInputFormatter cardInputFormatter() {
    return TextInputFormatter.withFunction((oldValue, newValue) {
      String text = newValue.text;
      //获取光标左边的文本
      final positionStr = (text.substring(0, newValue.selection.baseOffset)).replaceAll(RegExp(r"\s+\b|\b\s"), "");
      //计算格式化后的光标位置
      int length = positionStr.length;
      var position = 0;
      if (length <= 4) {
        position = length;
      } else if (length <= 8) {
        // 因为前面的字符串里面加了一个空格
        position = length + 1;
      } else if (length <= 12) {
        // 因为前面的字符串里面加了两个空格
        position = length + 2;
      } else if (length <= 16) {
        // 因为前面的字符串里面加了两个空格
        position = length + 3;
      } else {
        // 号码本身为 11 位数字，因多了两个空格，故为 13
        position = length + 4;
      }

      //这里格式化整个输入文本
      text = text.replaceAll(RegExp(r"\s+\b|\b\s"), "");
      var string = "";
      for (int i = 0; i < text.length; i++) {
        // 这里第 4 位，与第 8 位，我们用空格填充
        if (i == 4 || i == 8 || i == 12 || i == 16) {
          if (text[i] != ' ') {
            string = '$string ';
          }
        }
        string += text[i];
      }

      return TextEditingValue(
        text: string,
        selection: TextSelection.fromPosition(TextPosition(offset: position, affinity: TextAffinity.upstream)),
      );
    });
  }

  ITextField({
    Key? key,
    ITextInputType keyboardType: ITextInputType.text,
    this.maxLines = 1,
    this.minLines = 1,
    this.maxLength,
    this.hintText,
    this.digitsOnly,
    this.hintStyle,
    this.onChanged,
    this.suffixIconWidth,
    this.cursorColor,
    this.deleteIcon,
    this.inputBorder,
    this.textStyle,
    this.prefixIcon,
    this.prefixIconConstraints,
    this.suffixIcon,
    this.obscureText,
    this.enabledBorder,
    this.focusedBorder,
    this.focusNode,
    this.labelText,
    required this.controller,
    this.contentPadding,
    this.validator,
    this.showDeleteIcon = true,
    this.labelStyle,
    this.errorStyle,
    this.errorMaxLines,
    this.errorBorder,
    this.focusedErrorBorder,
    this.readOnly = false,
    this.onAppPrivateCommand,
    this.onEditingComplete,
    this.onSubmitted,
    this.onTap,
    this.textAlign = TextAlign.start,
    this.separator = '/',
    this.countWidgetStyle,
    this.countWidgetCountStyle,
    this.countWidgetLengthStyle,
    this.countWidgetSeparatorStyle,
    this.isCount = false,
    this.countWidgetAlignment = Alignment.centerRight,
    this.countCalculate = _calculate,
    this.inputFormatters,
    this.autofocus = false,
    this.closeIconColor,
  })  : keyboardType = maxLines == 1 ? keyboardType : ITextInputType.multiline,
        super(key: key);

  @override
  State<StatefulWidget> createState() => _ITextFieldState();
}

class _ITextFieldState extends State<ITextField> {
  bool _isNumber = false;

  ///输入类型
  TextInputType _getTextInputType() {
    switch (widget.keyboardType) {
      case ITextInputType.text:
        return TextInputType.text;
      case ITextInputType.multiline:
        return TextInputType.multiline;
      case ITextInputType.number:
        _isNumber = true;
        setState(() {});
        return TextInputType.number;
      case ITextInputType.phone:
        _isNumber = true;
        return TextInputType.phone;
      case ITextInputType.datetime:
        return TextInputType.datetime;
      case ITextInputType.emailAddress:
        return TextInputType.emailAddress;
      case ITextInputType.url:
        return TextInputType.url;
      case ITextInputType.password:
        return TextInputType.text;
      default:
        return TextInputType.text;
    }
  }

  /// 输入范围
  List<TextInputFormatter>? _getTextInputFormatter() {
    return _isNumber && (widget.digitsOnly == true)
        ? <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(widget.maxLength ?? -1)]
        : widget.maxLength != null
            ? <TextInputFormatter>[LengthLimitingTextInputFormatter(widget.maxLength)]
            : null;
  }

  @override
  Widget build(BuildContext context) {
    InputDecorationTheme theme = Theme.of(context).inputDecorationTheme;
    return Stack(
      children: [
        TextField(
          controller: widget.controller,
          focusNode: widget.focusNode,
          cursorColor: widget.cursorColor,
          enableInteractiveSelection: true,
          readOnly: widget.readOnly,
          onSubmitted: widget.onSubmitted,
          onTap: widget.onTap,
          autofocus: widget.autofocus,
          onAppPrivateCommand: widget.onAppPrivateCommand,
          onEditingComplete: widget.onEditingComplete,
          textAlign: widget.textAlign,
          decoration: InputDecoration(
            hintStyle: widget.hintStyle ?? theme.hintStyle,
            counterStyle: TextStyle(color: Colors.white),
            hintText: widget.hintText,
            errorStyle: widget.errorStyle ?? theme.errorStyle,
            errorMaxLines: widget.errorMaxLines,
            errorBorder: widget.errorBorder ?? theme.errorBorder,
            focusedErrorBorder: widget.focusedErrorBorder ?? theme.focusedErrorBorder,
            border: widget.inputBorder ?? theme.border,
            focusedBorder: widget.focusedBorder ?? theme.focusedBorder,
            enabledBorder: widget.enabledBorder ?? theme.enabledBorder,
            labelText: widget.labelText,
            labelStyle: widget.labelStyle ?? theme.labelStyle,
            contentPadding: widget.contentPadding,
            prefixIcon: widget.prefixIcon,
            prefixIconConstraints: widget.prefixIconConstraints,
            suffixIconConstraints: BoxConstraints(
              maxWidth: widget.suffixIcon != null ? widget.suffixIconWidth ?? 85 : 35,
            ),
            suffixIcon: widget.readOnly
                ? null
                : !widget.showDeleteIcon
                    ? null
                    : Container(
                        alignment: Alignment.centerRight,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            widget.showDeleteIcon
                                ? !widget.readOnly
                                    ? Container(
                                        width: 20.0,
                                        height: 20.0,
                                        margin: EdgeInsets.only(right: 10),
                                        child: widget.controller.text.length > 0
                                            ? IconButton(
                                                alignment: Alignment.center,
                                                padding: EdgeInsets.all(0.0),
                                                iconSize: 18.0,
                                                icon: widget.deleteIcon != null
                                                    ? widget.deleteIcon!
                                                    : Icon(
                                                        Icons.cancel,
                                                        color: widget.closeIconColor ?? Color.fromRGBO(0, 0, 0, 0.3),
                                                      ),
                                                onPressed: () {
                                                  widget.controller.clear();
                                                  setState(() {
                                                    widget.onChanged?.call(widget.controller.text);
                                                  });
                                                },
                                              )
                                            : null,
                                      )
                                    : Container()
                                : Container(),
                            widget.suffixIcon ?? Container(),
                          ],
                        ),
                      ),
          ),
          onChanged: (val) {
            String v = val;
            if (widget.maxLength != null) {
              v = widget.countCalculate(val, widget.maxLength!).text;
            }
            setState(() {
              widget.onChanged?.call(v);
            });
          },
          keyboardType: _getTextInputType(),
          maxLines: widget.maxLines,
          minLines: widget.minLines,
          inputFormatters: [...(widget.inputFormatters ?? []), ...(_getTextInputFormatter() ?? [])],
          style: widget.textStyle,
          obscureText: widget.obscureText ?? false,
        ),
        if (widget.maxLength != null && widget.isCount)
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            top: 0,
            child: Container(
              alignment: widget.countWidgetAlignment,
              child: _ICountText(
                count: widget.countCalculate(widget.controller.text, widget.maxLength!).length,
                maxLength: widget.maxLength!,
                style: widget.countWidgetStyle ?? TextStyle(color: Theme.of(context).hintColor),
                countStyle: widget.countWidgetCountStyle,
                lengthStyle: widget.countWidgetLengthStyle,
                separatorStyle: widget.countWidgetSeparatorStyle,
                separator: widget.separator,
              ),
            ),
          ),
      ],
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    widget.controller._bindTextState(this);
  }
}

class ITextEditingController extends TextEditingController {
  ITextEditingController({String? text});

  _ITextFieldState? _state;

  /// 绑定状态
  void _bindTextState(_ITextFieldState state) {
    _state = state;
  }
}

/// 计数器
class _ICountText extends StatelessWidget {
  final int count;

  final int maxLength;

  /// 分隔符
  final String separator;

  final TextStyle? style;

  final TextStyle? countStyle;

  final TextStyle? lengthStyle;

  final TextStyle? separatorStyle;

  const _ICountText({
    Key? key,
    required this.count,
    required this.maxLength,
    this.separator = '/',
    this.style,
    this.countStyle,
    this.lengthStyle,
    this.separatorStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(text: '$count', style: countStyle),
          TextSpan(text: separator, style: separatorStyle),
          TextSpan(text: '$maxLength', style: lengthStyle),
        ],
        style: style,
      ),
    );
  }
}
