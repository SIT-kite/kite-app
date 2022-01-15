import 'package:dio/dio.dart';
import 'package:kite/services/abstract_session.dart';

class LibrarySession extends ASession {
  @override
  Future<Response> request(
    String url,
    String method, {
    Map<String, String>? queryParameters,
    data,
    ResponseType? responseType,
  }) {
    // TODO: implement request
    throw UnimplementedError();
  }
}
