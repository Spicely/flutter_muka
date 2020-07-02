import 'package:json_annotation/json_annotation.dart';

part 'index.g.dart';

@JsonSerializable()
class DialogShareData {
  DialogShareData(this.icon, this.title, this.key);

  /// 本地图片地址
  String icon;

  /// 文本内容
  String title;

  /// 键 [尽量是唯一值]
  String key;

  DialogShareData.empty();

  factory DialogShareData.fromJson(Map<String, dynamic> json) => _$DialogShareDataFromJson(json);

  Map<String, dynamic> toJson() => _$DialogShareDataToJson(this);
}
