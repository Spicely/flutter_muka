class HttpResponse {
  int? status;
  
  String? msg;

  dynamic data;
  
  HttpResponse(this.status, this.msg, this.data);

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

Map<String, dynamic> _$HttpResponseToJson(HttpResponse instance) =>
    <String, dynamic>{
      'status': instance.status,
      'msg': instance.msg,
      'data': instance.data,
    };
