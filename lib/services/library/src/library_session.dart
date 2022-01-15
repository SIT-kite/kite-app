import 'package:dio/src/options.dart';
import 'package:dio/src/response.dart';
import 'package:kite/services/session_interface.dart';

class LibrarySession extends ISession {
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
