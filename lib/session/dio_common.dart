import 'package:dio/dio.dart';
import 'package:kite/abstract/abstract_session.dart';

extension RequestMethodEnumToString on RequestMethod {
  String toUpperCaseString() {
    return name.toUpperCase();
  }
}

extension MyResponseTypeToDioResponseType on MyResponseType {
  ResponseType toDioResponseType() {
    return {
      MyResponseType.json: ResponseType.json,
      MyResponseType.stream: ResponseType.stream,
      MyResponseType.plain: ResponseType.plain,
      MyResponseType.bytes: ResponseType.bytes,
    }[this]!;
  }
}

extension MyOptionsToDioOptions on MyOptions {
  Options toDioOptions() {
    return Options(
      method: method,
      sendTimeout: sendTimeout,
      receiveTimeout: receiveTimeout,
      extra: extra,
      headers: headers,
      responseType: responseType?.toDioResponseType(),
      contentType: contentType,
    );
  }
}

extension DioResponseToMyResponse on Response {
  MyResponse toMyResponse() {
    return MyResponse(
      data: data,
      realUri: realUri,
    );
  }
}

class MyDioDownloader implements IDownloader {
  Dio dio;
  MyDioDownloader(this.dio);

  @override
  Future<void> download(
    String url, {
    String? savePath,
    MyProgressCallback? onReceiveProgress,
    Map<String, String>? queryParameters,
    data,
    MyOptions? options,
  }) async {
    await dio.download(
      url,
      savePath,
      onReceiveProgress: onReceiveProgress,
      queryParameters: queryParameters,
      data: data,
      options: options?.toDioOptions(),
    );
  }
}

mixin MyDioDownloaderMixin implements IDownloader {
  Dio get dio;

  @override
  Future<void> download(
    String url, {
    String? savePath,
    MyProgressCallback? onReceiveProgress,
    Map<String, String>? queryParameters,
    data,
    MyOptions? options,
  }) async {
    await MyDioDownloader(dio).download(
      url,
      savePath: savePath,
      onReceiveProgress: onReceiveProgress,
      queryParameters: queryParameters,
      data: data,
      options: options,
    );
  }
}

class DefaultDioSession with MyDioDownloaderMixin implements ISession {
  @override
  Dio dio;

  DefaultDioSession(this.dio);

  @override
  Future<MyResponse> request(
    String url,
    RequestMethod method, {
    Map<String, String>? queryParameters,
    data,
    MyOptions? options,
    MyProgressCallback? onSendProgress,
    MyProgressCallback? onReceiveProgress,
  }) async {
    final response = await dio.request(
      url,
      queryParameters: queryParameters,
      data: data,
      options: options?.toDioOptions().copyWith(
            method: method.name.toUpperCase(),
          ),
    );
    return response.toMyResponse();
  }
}
