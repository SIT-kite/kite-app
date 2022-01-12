import 'package:dio/dio.dart';

abstract class ISession {
  Future<Response> get(
    String url, {
    Map<String, String>? queryParameters,
    ResponseType? responseType,
  });

  Future<Response> post(
    String url, {
    Map<String, String>? queryParameters,
    dynamic data,
    ResponseType? responseType,
  });
}
