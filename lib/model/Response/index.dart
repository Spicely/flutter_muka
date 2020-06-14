import 'package:json_annotation/json_annotation.dart';

part 'index.g.dart';

@JsonSerializable()
class HttpResponse {
  int status;
  
  String msg;

  dynamic data;
  
  HttpResponse(this.status, this.msg, this.data);

  HttpResponse.empty();

  factory HttpResponse.fromJson(Map<String, dynamic> json) => _$HttpResponseFromJson(json);
  
  Map<String, dynamic> toJson() => _$HttpResponseToJson(this);
}
