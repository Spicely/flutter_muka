class Update {
  /// 是否更新
  bool hasUpdate;

  /// 是否强制更新
  bool isIgnorable;

  /// 是否跳转appStore
  bool isAppStore;

  /// app版本号
  String versionCode;

  /// app大小
  String apkSize;

  /// 下载地址
  String downloadUrl;

  /// 更新内容
  String updateContent;

  Update(
    this.hasUpdate,
    this.apkSize,
    this.isAppStore,
    this.downloadUrl,
    this.updateContent,
    this.isIgnorable,
    this.versionCode,
  );

  Update.empty();

  factory Update.fromJson(Map<String, dynamic> json) => _$UpdateFromJson(json);

  Map<String, dynamic> toJson() => _$UpdateToJson(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Update _$UpdateFromJson(Map<String, dynamic> json) {
  return Update(
    json['hasUpdate'] as bool,
    json['apkSize'] as String,
    json['isAppStore'] as bool,
    json['downloadUrl'] as String,
    json['updateContent'] as String,
    json['isIgnorable'] as bool,
    json['versionCode'] as String,
  );
}

Map<String, dynamic> _$UpdateToJson(Update instance) => <String, dynamic>{
      'hasUpdate': instance.hasUpdate,
      'isIgnorable': instance.isIgnorable,
      'isAppStore': instance.isAppStore,
      'versionCode': instance.versionCode,
      'apkSize': instance.apkSize,
      'downloadUrl': instance.downloadUrl,
      'updateContent': instance.updateContent,
    };