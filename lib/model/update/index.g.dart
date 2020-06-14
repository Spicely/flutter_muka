// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'index.dart';

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
