part of flutter_muka;

/////////////////////////////////////////////////////////////////////////
//// All rights reserved.
//// author: Spicely
//// Summary: 虚拟键盘
//// Date: 2021年06月10日 11:30:37 Thursday
//////////////////////////////////////////////////////////////////////////

typedef void VirtualKeyboardChanged(String val);

typedef void VirtualKeyboardComplete(String val);

class VirtualKeyboard extends StatefulWidget {
  final Widget child;

  final String completeText;

  final VirtualKeyboardChanged? onChanged;

  final VirtualKeyboardComplete? onComplete;

  /// 控制器
  final VirtualKeyboardController controller;

  final int decimalLength;

  const VirtualKeyboard({
    Key? key,
    required this.child,
    this.completeText = '完成',
    required this.controller,
    this.onChanged,
    this.decimalLength = 2,
    this.onComplete,
  }) : super(key: key);

  @override
  _VirtualKeyboardState createState() => _VirtualKeyboardState();
}

class _VirtualKeyboardState extends State<VirtualKeyboard> {
  String _price = '';

  bool _status = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    widget.controller._bindState(this);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        if (_status)
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              height: 224,
              color: Color.fromRGBO(247, 247, 247, 1),
              padding: EdgeInsets.only(left: 5, bottom: 5),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: _getKeybordView(_getKeybordText('1'), val: '1'),
                      ),
                      Expanded(
                        child: _getKeybordView(_getKeybordText('2'), val: '2'),
                      ),
                      Expanded(
                        child: _getKeybordView(_getKeybordText('3'), val: '3'),
                      ),
                      Expanded(
                        child: _getKeybordView(Image.asset('assets/images/remove.png', package: 'flutter_muka', width: 18.5), val: 'del'),
                      ),
                    ],
                  ),
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: _getKeybordView(_getKeybordText('4'), val: '4'),
                                  ),
                                  Expanded(
                                    child: _getKeybordView(_getKeybordText('5'), val: '5'),
                                  ),
                                  Expanded(
                                    child: _getKeybordView(_getKeybordText('6'), val: '6'),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: _getKeybordView(_getKeybordText('7'), val: '7'),
                                  ),
                                  Expanded(
                                    child: _getKeybordView(_getKeybordText('8'), val: '8'),
                                  ),
                                  Expanded(
                                    child: _getKeybordView(_getKeybordText('9'), val: '9'),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: _getKeybordView(_getKeybordText('0'), val: '0'),
                                  ),
                                  Expanded(
                                    child: _getKeybordView(_getKeybordText('.'), val: '.'),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: GestureDetector(
                              child: Container(
                                height: double.infinity,
                                alignment: Alignment.center,
                                margin: EdgeInsets.only(top: 5, right: 5),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: double.parse(_price.isEmpty ? '0' : _price) == 0
                                      ? Color.fromRGBO(7, 193, 96, 0.6)
                                      : Color.fromRGBO(7, 193, 96, 1),
                                ),
                                child: Text(widget.completeText,
                                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Colors.white)),
                              ),
                              onTap: () {
                                if (double.parse(_price.isEmpty ? '0' : _price) != 0) {
                                  _hideKeybord();
                                  widget.onComplete?.call(_price);
                                }
                              }),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  Widget _getKeybordView(Widget child, {bool topMar = true, String val = ''}) {
    return GestureDetector(
      child: Container(
        height: 49.7,
        margin: EdgeInsets.only(right: 5, top: topMar ? 5 : 0),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: Colors.white,
        ),
        child: child,
      ),
      onTap: () {
        if (val == 'del') {
          if (_price.length > 0) _price = _price.substring(0, _price.length - 1);
        } else {
          if (_price.indexOf('.') == -1) _price += val;
          if (_price.indexOf('.') != -1 && val != '.') _price += val;
        }
        List _arr = _price.split('.');
        if (_arr.length > 1 && _arr[_arr.length - 1] != '')
          _arr[_arr.length - 1] = (_arr[_arr.length - 1] as String).substring(
              0,
              (_arr[_arr.length - 1] as String).length < widget.decimalLength
                  ? (_arr[_arr.length - 1] as String).length
                  : widget.decimalLength);
        _price = _arr.join('.');
        widget.onChanged?.call(_price);
        setState(() {});
      },
    );
  }

  Widget _getKeybordText(String val) {
    return Text(
      val,
      style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
    );
  }

  void _showKeybord(String price) {
    _status = true;
    _price = price;
    setState(() {});
  }

  void _hideKeybord() {
    _status = false;
    setState(() {});
  }
}

class VirtualKeyboardController {
  _VirtualKeyboardState? _state;

  /// 绑定状态
  void _bindState(_VirtualKeyboardState state) {
    _state = state;
  }

  /// 显示键盘
  void showKeybord(String price) {
    _state?._showKeybord(price);
  }

  /// 隐藏键盘
  void hideKeybord() {
    _state?._hideKeybord();
  }
}
