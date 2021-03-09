import 'dart:typed_data';

import 'package:dio/dio.dart';

class BrowserHttpClientAdapter implements HttpClientAdapter {
  bool withCredentials = false;

  @override
  void close({bool force = false}) {}

  @override
  Future<ResponseBody> fetch(RequestOptions options, Stream<Uint8List>? requestStream, Future? cancelFuture) {
    throw UnimplementedError();
  }
}
