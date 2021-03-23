import 'package:json_annotation/json_annotation.dart';

part 'index.g.dart';

@JsonSerializable()
class Update {
  /// 是否更新
  bool? hasUpdate;

  /// 是否强制更新
  bool? isIgnorable;

  /// 更新类型
  ///
  /// normal 全量升级
  ///
  /// hotUpgrade 热更新
  ///
  /// incrementUpgrade 增量升级
  final String type;

  /// 是否跳转appStore
  bool? isAppStore;

  /// app版本号
  String? versionCode;

  /// app大小
  String? apkSize;

  /// 下载地址
  ///
  /// 如果是IOS下载地址填写APPID
  String? downloadUrl;

  /// 更新内容
  String? updateContent;

  Update({
    this.hasUpdate,
    this.apkSize,
    this.isAppStore,
    this.downloadUrl,
    this.updateContent,
    this.isIgnorable,
    this.versionCode,
    this.type = 'normal',
  });

  Update.empty(this.type);

  factory Update.fromJson(Map<String, dynamic> json) => _$UpdateFromJson(json);

  Map<String, dynamic> toJson() => _$UpdateToJson(this);
}
