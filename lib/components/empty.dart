part of muka;

/////////////////////////////////////////////////////////////////////////
//// All rights reserved.
//// author: Spicely
//// Summary: 空组件样式
//// Date: 2020年06月19日 20:33:24 Friday
//////////////////////////////////////////////////////////////////////////
class Empty {
  /// 空数据图片地址
  static String GLOBAL_EMPTY_DATA_URL;

  /// 无网络图片地址
  static String GLOBAL_ERROR_NOTWORK_URL;

  static Widget view({
    Widget child,
  }) {
    return StatefulBuilder(builder: (context, state) {
      
      return Stack(
        children: <Widget>[
          child ?? Container(),
          Container()
        ],
      );
    });
  }
}
