class HttpResponse {
  int? code;

  String? msg;

  dynamic data;

  HttpResponse(this.code, this.msg, this.data);

  HttpResponse.empty();

  factory HttpResponse.fromJson(Map<String, dynamic> json) => _$HttpResponseFromJson(json);

  Map<String, dynamic> toJson() => _$HttpResponseToJson(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HttpResponse _$HttpResponseFromJson(Map<String, dynamic> json) {
  return HttpResponse(
    json['status'] as int?,
    json['msg'] as String?,
    json['data'],
  );
}

Map<String, dynamic> _$HttpResponseToJson(HttpResponse instance) => <String, dynamic>{
      'code': instance.code,
      'msg': instance.msg,
      'data': instance.data,
    };
