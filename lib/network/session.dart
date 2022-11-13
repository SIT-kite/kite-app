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

class SessionRes<T> {
  T data;
  Uri realUri;

  SessionRes({
    required this.data,
    required this.realUri,
  });
}

enum SessionResType { json, stream, plain, bytes }

class HeaderConstants {
  static const jsonContentType = 'application/json; charset=utf-8';
  static const formUrlEncodedContentType = 'application/x-www-form-urlencoded;charset=utf-8';
  static const textPlainContentType = 'text/plain';
}

class SessionOptions {
  String? method;
  int? sendTimeout;
  int? receiveTimeout;
  Map<String, dynamic>? extra;
  Map<String, dynamic>? headers;
  SessionResType? responseType;
  String? contentType;

  SessionOptions({
    this.method,
    this.sendTimeout,
    this.receiveTimeout,
    this.extra,
    this.headers,
    this.responseType,
    this.contentType,
  });
}

typedef SessionProgressCallback = void Function(int count, int total);

enum ReqMethod {
  get("GET"),
  post("POST"),
  delete("DELETE"),
  patch("PATCH"),
  update("UPDATE"),
  put("PUT");

  final String uppercaseName;

  const ReqMethod(this.uppercaseName);
}

abstract class ISession {
  Future<SessionRes> request(
    String url,
    ReqMethod method, {
    Map<String, String>? para,
    dynamic data,
    SessionOptions? options,
    SessionProgressCallback? onSendProgress,
    SessionProgressCallback? onReceiveProgress,
  });
}
