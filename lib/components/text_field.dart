/////////////////////////////////////////////////////////////////////////
//// All rights reserved.
//// author: Spicely
//// Summary: 组件样式ITextField
//// Date: 2020年05月26日 15:19:53 Tuesday
//////////////////////////////////////////////////////////////////////////
part of '../muka.dart';

///自带删除的ITextField
typedef void ITextFieldCallBack(String content);

enum ITextInputType {
  text,
  multiline,
  number,
  phone,
  datetime,
  emailAddress,
  url,
  password
}

class ITextField extends StatefulWidget {
  final ITextInputType keyboardType;

  final int maxLines;

  final int maxLength;

  final String hintText;

  final TextStyle hintStyle;

  final ITextFieldCallBack fieldCallBack;

  final Icon deleteIcon;

  final InputBorder inputBorder;

  final InputBorder focusedBorder;

  final InputBorder enabledBorder;

  final double suffixIconWidth;

  final Widget prefixIcon;

  final TextStyle textStyle;

  final Widget suffixIcon;

  final bool digitsOnly;

  final Color cursorColor;

  final bool obscureText;

  final EdgeInsetsGeometry contentPadding;

  final FormFieldValidator<String> validator;

  final String value;

  ITextField({
    Key key,
    ITextInputType keyboardType: ITextInputType.text,
    this.maxLines = 1,
    this.maxLength,
    this.hintText,
    this.digitsOnly,
    this.hintStyle,
    this.fieldCallBack,
    this.suffixIconWidth,
    this.cursorColor,
    this.deleteIcon,
    this.inputBorder,
    this.textStyle,
    this.prefixIcon,
    this.suffixIcon,
    this.obscureText,
    this.enabledBorder,
    this.focusedBorder,
    @required this.value,
    this.contentPadding = const EdgeInsets.symmetric(vertical: 0, horizontal: 15),
    this.validator,
  })  : assert(maxLines == null || maxLines > 0),
        assert(maxLength == null || maxLength > 0),
        keyboardType = maxLines == 1 ? keyboardType : ITextInputType.multiline,
        super(key: key);

  @override
  State<StatefulWidget> createState() => _ITextFieldState();
}

class _ITextFieldState extends State<ITextField> {
  String _inputText = '';
  bool _status = true;
  bool _hasdeleteIcon = false;
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

  ///输入范围
  List<TextInputFormatter> _getTextInputFormatter() {
    return _isNumber && (widget.digitsOnly == true)
        ? <TextInputFormatter>[
            WhitelistingTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(widget.maxLength ?? -1)
          ]
        : widget.maxLength != null
            ? <TextInputFormatter>[
                LengthLimitingTextInputFormatter(widget.maxLength)
              ]
            : null;
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController _controller = TextEditingController.fromValue(
      TextEditingValue(
        text: _status ? widget.value : _inputText,
        selection: TextSelection.fromPosition(
          TextPosition(
            affinity: TextAffinity.downstream,
            offset: _status ? widget.value?.length ?? 0 : _inputText.length,
          ),
        ),
      ),
    );
    TextField textField = TextField(
      controller: _controller,
      cursorColor: widget.cursorColor ?? Theme.of(context).primaryColor,
      enableInteractiveSelection: true,
      decoration: InputDecoration(
        hintStyle: widget.hintStyle,
        contentPadding: widget.contentPadding,
        counterStyle: TextStyle(color: Colors.white),
        hintText: widget.hintText,
        border: widget.inputBorder != null
            ? widget.inputBorder
            : UnderlineInputBorder(),
        focusedBorder: widget.focusedBorder,
        enabledBorder: widget.enabledBorder,
        fillColor: Colors.transparent,
        // filled: true,
        prefixIcon: widget.prefixIcon,
        suffixIcon: Container(
          alignment: Alignment.centerRight,
          width: widget.suffixIcon != null ? widget.suffixIconWidth ?? 85 : 40,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              (_hasdeleteIcon || (_status && widget.value?.length != 0))
                  ? Container(
                      width: 20.0,
                      height: 20.0,
                      child: IconButton(
                        alignment: Alignment.center,
                        padding: EdgeInsets.all(0.0),
                        iconSize: 18.0,
                        icon: widget.deleteIcon != null
                            ? widget.deleteIcon
                            : Icon(
                                Icons.cancel,
                                color: Color.fromRGBO(0, 0, 0, 0.3),
                              ),
                        onPressed: () {
                          _status = false;
                          setState(() {
                            _inputText = "";
                            _hasdeleteIcon = (_inputText.isNotEmpty);
                            widget.fieldCallBack(_inputText);
                          });
                        },
                      ),
                    )
                  : Container(),
              widget.suffixIcon ?? Container(),
            ],
          ),
        ),
      ),
      onChanged: (str) {
        _status = false;
        setState(() {
          _inputText = str;
          _hasdeleteIcon = (_inputText.isNotEmpty);
          widget.fieldCallBack(_inputText);
        });
      },
      keyboardType: _getTextInputType(),
      maxLines: widget.maxLines,
      inputFormatters: _getTextInputFormatter(),
      style: widget.textStyle,
      obscureText: widget.obscureText ?? false,
    );
    return textField;
  }
}