class DialogShareData {
  DialogShareData(this.icon, this.title, this.key);

  /// 本地图片地址
  String? icon;

  /// 文本内容
  String? title;

  /// 键 [尽量是唯一值]
  String? key;

  DialogShareData.empty();

  factory DialogShareData.fromJson(Map<String, dynamic> json) => _$DialogShareDataFromJson(json);

  Map<String, dynamic> toJson() => _$DialogShareDataToJson(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DialogShareData _$DialogShareDataFromJson(Map<String, dynamic> json) {
  return DialogShareData(
    json['icon'] as String?,
    json['title'] as String?,
    json['key'] as String?,
  );
}

Map<String, dynamic> _$DialogShareDataToJson(DialogShareData instance) => <String, dynamic>{
      'icon': instance.icon,
      'title': instance.title,
      'key': instance.key,
    };
