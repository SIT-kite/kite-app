import 'package:dio/dio.dart';

abstract class ASession {
  Future<Response> request(
    String url,
    String method, {
    Map<String, String>? queryParameters,
    dynamic data,
    Options? options,
    String? contentType,
    ResponseType? responseType,
  });

  Future<Response> get(
    String url, {
    Map<String, String>? queryParameters,
    String? contentType,
    ResponseType? responseType,
    Options? options,
  }) {
    return request(
      url,
      'GET',
      queryParameters: queryParameters,
      contentType: contentType,
      responseType: responseType,
      options: options,
    );
  }

  Future<Response> post(
    String url, {
    Map<String, String>? queryParameters,
    dynamic data,
    String? contentType,
    ResponseType? responseType,
    Options? options,
  }) {
    return request(
      url,
      'POST',
      queryParameters: queryParameters,
      data: data,
      contentType: contentType,
      responseType: responseType,
      options: options,
    );
  }
}

class DefaultSession extends ASession {
  Dio dio;

  DefaultSession(this.dio);

  @override
  Future<Response> request(
    String url,
    String method, {
    Map<String, String>? queryParameters,
    dynamic data,
    Options? options,
    String? contentType,
    ResponseType? responseType,
  }) {
    return dio.request(
      url,
      data: data,
      queryParameters: queryParameters,
      options: (options ?? Options()).copyWith(
        method: method,
        contentType: contentType,
        responseType: responseType,
      ),
    );
  }
}
