import 'package:dio/dio.dart';

abstract class ASession {
  Future<Response> request(
    String url,
    String method, {
    Map<String, String>? queryParameters,
    dynamic data,
    Options? options,
    ResponseType? responseType,
  });

  Future<Response> get(
    String url, {
    Map<String, String>? queryParameters,
    ResponseType? responseType,
    Options? options,
  }) {
    return request(
      url,
      'GET',
      queryParameters: queryParameters,
      responseType: responseType,
      options: options,
    );
  }

  Future<Response> post(
    String url, {
    Map<String, String>? queryParameters,
    dynamic data,
    ResponseType? responseType,
    Options? options,
  }) {
    return request(
      url,
      'POST',
      queryParameters: queryParameters,
      data: data,
      responseType: responseType,
      options: options,
    );
  }
}

class DefaultSession extends ASession {
  var dio = Dio();
  @override
  Future<Response> request(
    String url,
    String method, {
    Map<String, String>? queryParameters,
    dynamic data,
    Options? options,
    ResponseType? responseType,
  }) {
    return dio.request(
      url,
      data: data,
      queryParameters: queryParameters,
      options: options?.copyWith(
        method: method,
        responseType: responseType,
      ),
    );
  }
}
