class UpgradeModel {
  /// 是否更新
  final bool hasUpdate;

  /// 是否强制更新
  final bool isIgnorable;

  /// 更新类型
  ///
  /// normal 全量升级
  ///
  /// hotUpgrade 热更新
  ///
  /// incrementUpgrade 增量升级
  final String type;

  /// 是否跳转appStore
  final bool isAppStore;

  /// app版本号
  final String versionCode;

  /// app大小
  final String apkSize;

  /// 下载地址
  ///
  /// 如果是IOS下载地址填写APPID
  final String downloadUrl;

  /// 更新内容
  final String updateContent;

  UpgradeModel({
    required this.hasUpdate,
    required this.apkSize,
    required this.isAppStore,
    required this.downloadUrl,
    required this.updateContent,
    required this.isIgnorable,
    required this.versionCode,
    this.type = 'normal',
  });

  UpgradeModel.empty(
      this.hasUpdate, this.isIgnorable, this.type, this.isAppStore, this.versionCode, this.apkSize, this.downloadUrl, this.updateContent);

  factory UpgradeModel.fromJson(Map<String, dynamic> json) => _$UpgradeModelFromJson(json);

  Map<String, dynamic> toJson() => _$UpgradeModelToJson(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpgradeModel _$UpgradeModelFromJson(Map<String, dynamic> json) {
  return UpgradeModel(
    hasUpdate: json['hasUpdate'] as bool,
    apkSize: json['apkSize'] as String,
    isAppStore: json['isAppStore'] as bool,
    downloadUrl: json['downloadUrl'] as String,
    updateContent: json['updateContent'] as String,
    isIgnorable: json['isIgnorable'] as bool,
    versionCode: json['versionCode'] as String,
    type: json['type'] as String,
  );
}

Map<String, dynamic> _$UpgradeModelToJson(UpgradeModel instance) => <String, dynamic>{
      'hasUpdate': instance.hasUpdate,
      'isIgnorable': instance.isIgnorable,
      'type': instance.type,
      'isAppStore': instance.isAppStore,
      'versionCode': instance.versionCode,
      'apkSize': instance.apkSize,
      'downloadUrl': instance.downloadUrl,
      'updateContent': instance.updateContent,
    };
