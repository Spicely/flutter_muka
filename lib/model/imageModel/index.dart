import 'package:json_annotation/json_annotation.dart';

part 'index.g.dart';

@JsonSerializable()
class ImageModel {
  /// 状态
  bool status;

  /// 缩略地址
  String url;

  /// 原图地址
  String original;

  /// 高压地址
  String preview;

  /// 图片大小
  String size;

  /// 图片格式
  String mimeType;

  /// 图片高度
  double height;

  /// 图片宽度
  double width;

  /// 图片类型
  String type;

  /// 用户id
  String user;

  /// 上传时间
  double createdAt;

  /// 更新时间
  double updatedAt;

  /// id
  String id;

  ImageModel(
    this.preview,
    this.status,
    this.createdAt,
    this.height,
    this.id,
    this.mimeType,
    this.original,
    this.size,
    this.type,
    this.updatedAt,
    this.url,
    this.user,
    this.width,
  );

  ImageModel.empty();

  factory ImageModel.fromJson(Map<String, dynamic> json) => _$ImageModelFromJson(json);

  Map<String, dynamic> toJson() => _$ImageModelToJson(this);
}
