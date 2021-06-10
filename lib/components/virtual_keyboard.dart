part of flutter_muka;

/////////////////////////////////////////////////////////////////////////
//// All rights reserved.
//// author: Spicely
//// Summary: 虚拟键盘
//// Date: 2021年06月10日 11:30:37 Thursday
//////////////////////////////////////////////////////////////////////////

class VirtualKeyboard extends StatefulWidget {
  final Widget child;

  final String completeText;

  const VirtualKeyboard({
    Key? key,
    required this.child,
    this.completeText = '完成',
  }) : super(key: key);

  @override
  _VirtualKeyboardState createState() => _VirtualKeyboardState();
}

class _VirtualKeyboardState extends State<VirtualKeyboard> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
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
                      child: _getKeybordView(_getKeybordText('1')),
                    ),
                    Expanded(
                      child: _getKeybordView(_getKeybordText('2')),
                    ),
                    Expanded(
                      child: _getKeybordView(_getKeybordText('3')),
                    ),
                    Expanded(
                      child: _getKeybordView(Image.asset('assets/images/remove.png', package: 'flutter_muka', width: 18.5)),
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
                                  child: _getKeybordView(_getKeybordText('4')),
                                ),
                                Expanded(
                                  child: _getKeybordView(_getKeybordText('5')),
                                ),
                                Expanded(
                                  child: _getKeybordView(_getKeybordText('6')),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: _getKeybordView(_getKeybordText('7')),
                                ),
                                Expanded(
                                  child: _getKeybordView(_getKeybordText('8')),
                                ),
                                Expanded(
                                  child: _getKeybordView(_getKeybordText('9')),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: _getKeybordView(_getKeybordText('0')),
                                ),
                                Expanded(
                                  child: _getKeybordView(_getKeybordText('.')),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Container(
                          height: double.infinity,
                          alignment: Alignment.center,
                          margin: EdgeInsets.only(top: 5, right: 5),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: Color.fromRGBO(7, 193, 96, 1),
                          ),
                          child:
                              Text(widget.completeText, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Colors.white)),
                        ),
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

  Widget _getKeybordView(Widget child, {bool topMar = true}) {
    return Container(
      height: 49.7,
      margin: EdgeInsets.only(right: 5, top: topMar ? 5 : 0),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: Colors.white,
      ),
      child: child,
    );
  }

  Widget _getKeybordText(String val) {
    return Text(
      val,
      style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
    );
  }
}
