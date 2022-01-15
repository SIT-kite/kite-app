import 'package:dio/dio.dart';

abstract class ASession {
  Future<Response> request(
    String url,
    String method, {
    Map<String, String>? queryParameters,
    dynamic data,
    ResponseType? responseType,
  });
  Future<Response> get(
    String url, {
    Map<String, String>? queryParameters,
    ResponseType? responseType,
  }) {
    return request(
      url,
      'GET',
      queryParameters: queryParameters,
      responseType: responseType,
    );
  }

  Future<Response> post(
    String url, {
    Map<String, String>? queryParameters,
    dynamic data,
    ResponseType? responseType,
  }) {
    return request(
      url,
      'POST',
      queryParameters: queryParameters,
      data: data,
      responseType: responseType,
    );
  }
}
