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

import '../../session/abstract_session.dart';
import '../../util/logger.dart';

class ScSession extends ASession {
  final ASession _session;

  ScSession(this._session) {
    Log.info('初始化 ScSession');
  }

  Future<void> _refreshCookie() async {
    await _session.get('https://authserver.sit.edu.cn/authserver/login?service=http%3A%2F%2Fsc.sit.edu.cn%2Flogin.jsp');
  }

  bool _isRedirectedToLoginPage(Response response) {
    return (response.data as String).startsWith('<script');
  }

  @override
  Future<Response> request(
    String url,
    String method, {
    Map<String, String>? queryParameters,
    data,
    String? contentType,
    ResponseType? responseType,
    Options? options,
  }) async {
    Future<Response> fetch() async {
      return await _session.request(
        url,
        method,
        queryParameters: queryParameters,
        data: data,
        contentType: contentType,
        responseType: responseType,
      );
    }

    Response response = await fetch();
    // 如果返回值是登录页面，那就从 SSO 跳转一次以登录.
    if (_isRedirectedToLoginPage(response)) {
      await _refreshCookie();
      response = await fetch();
    }
    return response;
  }
}
