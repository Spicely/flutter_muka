part of flutter_muka;
/*
 * Summary: flutter_muka 全局配置
 * Created Date: 2022-08-03 11:10:06
 * Author: Spicely
 * -----
 * Last Modified: 2022-08-03 11:24:52
 * Modified By: Spicely
 * -----
 * Copyright (c) 2022 Spicely Inc.
 * 
 * May the force be with you.
 * -----
 * HISTORY:
 * Date      	By	Comments
 */

class MukaConfigTheme {
  Widget emptyWidget() => SizedBox(child: Text('暂无数据'));
}

class MukaConfig {
  static MukaConfigTheme config = MukaConfigTheme();
}
