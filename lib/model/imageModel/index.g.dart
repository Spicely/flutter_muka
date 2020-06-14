// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'index.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ImageModel _$ImageModelFromJson(Map<String, dynamic> json) {
  return ImageModel(
    json['preview'] as String,
    json['status'] as bool,
    (json['createdAt'] as num)?.toDouble(),
    (json['height'] as num)?.toDouble(),
    json['id'] as String,
    json['mimeType'] as String,
    json['original'] as String,
    json['size'] as String,
    json['type'] as String,
    (json['updatedAt'] as num)?.toDouble(),
    json['url'] as String,
    json['user'] as String,
    (json['width'] as num)?.toDouble(),
  );
}

Map<String, dynamic> _$ImageModelToJson(ImageModel instance) =>
    <String, dynamic>{
      'status': instance.status,
      'url': instance.url,
      'original': instance.original,
      'preview': instance.preview,
      'size': instance.size,
      'mimeType': instance.mimeType,
      'height': instance.height,
      'width': instance.width,
      'type': instance.type,
      'user': instance.user,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
      'id': instance.id,
    };
