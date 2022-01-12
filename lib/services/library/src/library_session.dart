import 'package:dio/dio.dart';
import 'package:kite/services/session_interface.dart';

class LibrarySession implements ISession {
  @override
  Future<Response> get(
    String url, {
    Map<String, String>? queryParameters,
    ResponseType? responseType,
  }) {
    // TODO: implement get
    throw UnimplementedError();
  }

  @override
  Future<Response> post(
    String url, {
    Map<String, String>? queryParameters,
    data,
    ResponseType? responseType,
  }) {
    // TODO: implement post
    throw UnimplementedError();
  }
}
