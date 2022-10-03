/*
 *    上应小风筝(SIT-kite)  便利校园，一步到位
 *    Copyright (C) 2022 上海应用技术大学 上应小风筝团队
 *
 *    This program is free software: you can redistribute it and/or modify
 *    it under the terms of the GNU General Public License as published by
 *    the Free Software Foundation, either version 3 of the License, or
 *    (at your option) any later version.
 *
 *    This program is distributed in the hope that it will be useful,
 *    but WITHOUT ANY WARRANTY; without even the implied warranty of
 *    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *    GNU General Public License for more details.
 *
 *    You should have received a copy of the GNU General Public License
 *    along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/
import 'package:dio/dio.dart';
import 'package:kite/network/session.dart';

import '../network/download.dart';

extension DioResTypeConverter on SessionResType {
  ResponseType toDioResponseType() {
    return (const {
      SessionResType.json: ResponseType.json,
      SessionResType.stream: ResponseType.stream,
      SessionResType.plain: ResponseType.plain,
      SessionResType.bytes: ResponseType.bytes,
    })[this]!;
  }
}

extension DioOptionsConverter on SessionOptions {
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

extension SessionResConverter on Response {
  SessionRes toMyResponse() {
    return SessionRes(
      data: data,
      realUri: realUri,
    );
  }
}

class DioDownloader implements Downloader {
  Dio dio;

  DioDownloader(this.dio);

  @override
  Future<void> download(
    String url, {
    String? savePath,
    SessionProgressCallback? onReceiveProgress,
    Map<String, String>? queryParameters,
    data,
    SessionOptions? options,
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

mixin DioDownloaderMixin implements Downloader {
  Dio get dio;

  @override
  Future<void> download(
    String url, {
    String? savePath,
    SessionProgressCallback? onReceiveProgress,
    Map<String, String>? queryParameters,
    data,
    SessionOptions? options,
  }) async {
    await DioDownloader(dio).download(
      url,
      savePath: savePath,
      onReceiveProgress: onReceiveProgress,
      queryParameters: queryParameters,
      data: data,
      options: options,
    );
  }
}

class DefaultDioSession with DioDownloaderMixin implements ISession {
  @override
  Dio dio;

  DefaultDioSession(this.dio);

  @override
  Future<SessionRes> request(
    String url,
    ReqMethod method, {
    Map<String, String>? queryParameters,
    data,
    SessionOptions? options,
    SessionProgressCallback? onSendProgress,
    SessionProgressCallback? onReceiveProgress,
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
