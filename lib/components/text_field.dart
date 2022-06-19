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

class ITextField extends StatefulWidget {
  final ITextInputType keyboardType;

  final int? maxLines;

  final int? maxLength;

  final String? hintText;

  final TextStyle? hintStyle;

  final ITextFieldCallBack? onChanged;

  final ITextFieldCallBack? onSubmitted;

  final GestureTapCallback? onEditingComplete;

  final GestureTapCallback? onTap;

  final ToolbarOptions? toolbarOptions;

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

  ITextField({
    Key? key,
    ITextInputType keyboardType: ITextInputType.text,
    this.maxLines,
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
    this.toolbarOptions,
  })  : keyboardType = maxLines == 1 ? keyboardType : ITextInputType.multiline,
        super(key: key);

  @override
  State<StatefulWidget> createState() => _ITextFieldState();
}

class _ITextFieldState extends State<ITextField> {
  bool _isNumber = false;

  String? _errorText;

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
    return TextField(
      controller: widget.controller,
      focusNode: widget.focusNode,
      cursorColor: widget.cursorColor,
      enableInteractiveSelection: true,
      readOnly: widget.readOnly,
      onSubmitted: widget.onSubmitted,
      onTap: widget.onTap,
      onAppPrivateCommand: widget.onAppPrivateCommand,
      onEditingComplete: widget.onEditingComplete,
      toolbarOptions: widget.toolbarOptions,
      textAlign: widget.textAlign,
      decoration: InputDecoration(
        hintStyle: widget.hintStyle,
        contentPadding: widget.contentPadding,
        counterStyle: TextStyle(color: Colors.white),
        hintText: widget.hintText,
        errorText: _errorText,
        errorStyle: widget.errorStyle,
        errorMaxLines: widget.errorMaxLines,
        errorBorder: widget.errorBorder,
        focusedErrorBorder: widget.focusedErrorBorder,
        border: widget.inputBorder != null ? widget.inputBorder : UnderlineInputBorder(),
        focusedBorder: widget.focusedBorder,
        enabledBorder: widget.enabledBorder,
        fillColor: Colors.transparent,
        labelText: widget.labelText,
        labelStyle: widget.labelStyle,
        filled: true,
        prefixIcon: widget.prefixIcon,
        prefixIconConstraints: widget.prefixIconConstraints,
        suffixIcon: !widget.showDeleteIcon
            ? null
            : Container(
                alignment: Alignment.centerRight,
                width: widget.suffixIcon != null ? widget.suffixIconWidth ?? 85 : 40,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    widget.showDeleteIcon
                        ? !widget.readOnly
                            ? Container(
                                width: 20.0,
                                height: 20.0,
                                child: widget.controller.text.length > 0
                                    ? IconButton(
                                        alignment: Alignment.center,
                                        padding: EdgeInsets.all(0.0),
                                        iconSize: 18.0,
                                        icon: widget.deleteIcon != null
                                            ? widget.deleteIcon!
                                            : Icon(
                                                Icons.cancel,
                                                color: Color.fromRGBO(0, 0, 0, 0.3),
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
        setState(() {
          widget.onChanged?.call(val);
        });
      },
      keyboardType: _getTextInputType(),
      maxLines: widget.maxLines,
      inputFormatters: _getTextInputFormatter(),
      style: widget.textStyle,
      obscureText: widget.obscureText ?? false,
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    widget.controller._bindTextState(this);
  }

  void _showError(String label) {
    setState(() {
      _errorText = label;
    });
  }

  void _clearError() {
    setState(() {
      _errorText = null;
    });
  }
}

class ITextEditingController extends TextEditingController {
  ITextEditingController({String? text});

  _ITextFieldState? _state;

  /// 绑定状态
  void _bindTextState(_ITextFieldState state) {
    _state = state;
  }

  /// 显示错误信息
  void showError(String label) {
    _state!._showError(label);
  }

  /// 删除错误信息
  void clearError() {
    _state!._clearError();
  }
}
