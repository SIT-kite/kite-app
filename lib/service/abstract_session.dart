import 'package:dio/dio.dart';

abstract class ASession {
  Future<Response<T>> request<T>(
    String url,
    String method, {
    Map<String, String>? queryParameters,
    dynamic data,
    Options? options,
    String? contentType,
    ResponseType? responseType,
  });

  Future<Response<T>> get<T>(
    String url, {
    Map<String, String>? queryParameters,
    String? contentType,
    ResponseType? responseType,
    Options? options,
  }) {
    return request<T>(
      url,
      'GET',
      queryParameters: queryParameters,
      contentType: contentType,
      responseType: responseType,
      options: options,
    );
  }

  Future<Response<T>> post<T>(
    String url, {
    Map<String, String>? queryParameters,
    dynamic data,
    String? contentType,
    ResponseType? responseType,
    Options? options,
  }) {
    return request<T>(
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
  Future<Response<T>> request<T>(
    String url,
    String method, {
    Map<String, String>? queryParameters,
    dynamic data,
    Options? options,
    String? contentType,
    ResponseType? responseType,
  }) {
    return dio.request<T>(
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
