// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'index.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Update _$UpdateFromJson(Map<String, dynamic> json) {
  return Update(
    hasUpdate: json['hasUpdate'] as bool?,
    apkSize: json['apkSize'] as String?,
    isAppStore: json['isAppStore'] as bool?,
    downloadUrl: json['downloadUrl'] as String?,
    updateContent: json['updateContent'] as String?,
    isIgnorable: json['isIgnorable'] as bool?,
    versionCode: json['versionCode'] as String?,
    type: json['type'] as String,
  );
}

Map<String, dynamic> _$UpdateToJson(Update instance) => <String, dynamic>{
      'hasUpdate': instance.hasUpdate,
      'isIgnorable': instance.isIgnorable,
      'type': instance.type,
      'isAppStore': instance.isAppStore,
      'versionCode': instance.versionCode,
      'apkSize': instance.apkSize,
      'downloadUrl': instance.downloadUrl,
      'updateContent': instance.updateContent,
    };
