/////////////////////////////////////////////////////////////////////////
//// All rights reserved.
//// author: Spicely
//// Summary: 监听页面是否显示
//// Date: 2024年01月26日 09:52:31 Friday
//////////////////////////////////////////////////////////////////////////
part of flutter_muka;

enum VisibilityState { hide, show }

mixin WidgetVisibilityStateMixin<T extends StatefulWidget> on State<T> implements WidgetsBindingObserver {
  late FocusNode _ownFocusNode, _oldFocusNode, _newFocusNode;
  VisibilityState visibilityState = VisibilityState.hide;

  ///忽略的焦点列表
  List<FocusNode> _ignoreFocusList = [];

  List<FocusNode> get ignoreFocusList => _ignoreFocusList;

  set ignoreFocusList(List<FocusNode> list) => _ignoreFocusList = list;

  void onShow() {
    visibilityState = VisibilityState.show;
  }

  void onHide() {
    visibilityState = VisibilityState.hide;
  }

  _addFocusNodeChangeCb() {
    _ownFocusNode = _oldFocusNode = _newFocusNode = FocusManager.instance.primaryFocus!;
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPersistentFrameCallback(focusNodeChangeCb);
    onShow();
  }

  void focusNodeChangeCb(_) {
    _newFocusNode = FocusManager.instance.primaryFocus!;
    if (_newFocusNode == _oldFocusNode) return;
    _oldFocusNode = _newFocusNode;

    if (_judgeNeedIgnore(_newFocusNode)) return;
    if (_newFocusNode == _ownFocusNode) {
      ///显示
      if (visibilityState != VisibilityState.show) {
        onShow();
      }
    } else {
      ///不显示
      if (visibilityState != VisibilityState.hide) {
        onHide();
      }
    }
  }

  bool _judgeNeedIgnore(focusNode) {
    return _ignoreFocusList.contains(focusNode);
  }

  @override
  void initState() {
    super.initState();
    Future(_addFocusNodeChangeCb);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
}

mixin WidgetVisibilityMixin implements WidgetsBindingObserver {
  late FocusNode _ownFocusNode, _oldFocusNode, _newFocusNode;
  VisibilityState visibilityState = VisibilityState.hide;

  ///忽略的焦点列表
  List<FocusNode> _ignoreFocusList = [];

  List<FocusNode> get ignoreFocusList => _ignoreFocusList;

  set ignoreFocusList(List<FocusNode> list) => _ignoreFocusList = list;

  void onShow() {
    visibilityState = VisibilityState.show;
  }

  void onHide() {
    visibilityState = VisibilityState.hide;
  }

  _addFocusNodeChangeCb() {
    _ownFocusNode = _oldFocusNode = _newFocusNode = FocusManager.instance.primaryFocus!;
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPersistentFrameCallback(focusNodeChangeCb);
    onShow();
  }

  void focusNodeChangeCb(_) {
    _newFocusNode = FocusManager.instance.primaryFocus!;
    if (_newFocusNode == _oldFocusNode) return;
    _oldFocusNode = _newFocusNode;

    if (_judgeNeedIgnore(_newFocusNode)) return;
    if (_newFocusNode == _ownFocusNode) {
      ///显示
      if (visibilityState != VisibilityState.show) {
        onShow();
      }
    } else {
      ///不显示
      if (visibilityState != VisibilityState.hide) {
        onHide();
      }
    }
  }

  bool _judgeNeedIgnore(focusNode) {
    return _ignoreFocusList.contains(focusNode);
  }

  void listen() {
    Future(_addFocusNodeChangeCb);
  }

  void removeListen() {
    WidgetsBinding.instance.removeObserver(this);
  }
}
