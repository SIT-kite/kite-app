/*
 * 上应小风筝  便利校园，一步到位
 * Copyright (C) 2022 上海应用技术大学 上应小风筝团队
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */
import 'package:dio/dio.dart';

abstract class ASession {
  Future<Response> request(
    String url,
    String method, {
    Map<String, String>? queryParameters,
    dynamic data,
    Options? options,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  });

  Future<Response> get(
    String url, {
    Map<String, String>? queryParameters,
    Options? options,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) {
    return request(
      url,
      'GET',
      queryParameters: queryParameters,
      options: options,
      onSendProgress: onReceiveProgress,
      onReceiveProgress: onReceiveProgress,
    );
  }

  Future<Response> post(
    String url, {
    Map<String, String>? queryParameters,
    dynamic data,
    Options? options,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) {
    return request(
      url,
      'POST',
      queryParameters: queryParameters,
      data: data,
      options: options,
      onSendProgress: onReceiveProgress,
      onReceiveProgress: onReceiveProgress,
    );
  }

  Future<Response> delete(
    String url, {
    Map<String, String>? queryParameters,
    dynamic data,
    Options? options,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) {
    return request(
      url,
      'DELETE',
      queryParameters: queryParameters,
      data: data,
      options: options,
      onSendProgress: onReceiveProgress,
      onReceiveProgress: onReceiveProgress,
    );
  }

  Future<Response> patch(
    String url, {
    Map<String, String>? queryParameters,
    dynamic data,
    Options? options,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) {
    return request(
      url,
      'PATCH',
      queryParameters: queryParameters,
      data: data,
      options: options,
      onSendProgress: onReceiveProgress,
      onReceiveProgress: onReceiveProgress,
    );
  }

  Future<Response> update(
    String url, {
    Map<String, String>? queryParameters,
    dynamic data,
    Options? options,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) {
    return request(
      url,
      'UPDATE',
      queryParameters: queryParameters,
      data: data,
      options: options,
      onSendProgress: onReceiveProgress,
      onReceiveProgress: onReceiveProgress,
    );
  }
}

mixin Downloader on ASession {
  Dio getDio();

  Future<Response> download(
    String url, {
    String? savePath,
    ProgressCallback? onReceiveProgress,
    Map<String, String>? queryParameters,
    data,
    String? contentType,
    Options? options,
  }) async {
    return await getDio().download(
      url,
      savePath,
      onReceiveProgress: onReceiveProgress,
      queryParameters: queryParameters,
      data: data,
      options: (options ?? Options()).copyWith(contentType: contentType),
    );
  }
}

class DefaultSession extends ASession with Downloader {
  Dio dio;

  DefaultSession(this.dio);

  @override
  Future<Response> request(
    String url,
    String method, {
    Map<String, String>? queryParameters,
    dynamic data,
    Options? options,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) {
    return dio.request(
      url,
      data: data,
      queryParameters: queryParameters,
      options: options,
      onSendProgress: onReceiveProgress,
      onReceiveProgress: onReceiveProgress,
    );
  }

  @override
  Dio getDio() {
    return dio;
  }
}
