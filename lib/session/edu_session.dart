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
import 'package:kite/network/session.dart';
import 'package:kite/session/sso/index.dart';
import 'package:kite/util/logger.dart';

class EduSession extends ISession {
  final SsoSession ssoSession;

  EduSession(this.ssoSession) {
    Log.info('初始化 EduSession');
  }

  Future<void> _refreshCookie() async {
    await ssoSession.request('http://jwxt.sit.edu.cn/sso/jziotlogin', ReqMethod.get);
  }

  bool _isRedirectedToLoginPage(SessionRes response) {
    return response.realUri.path == '/jwglxt/xtgl/login_slogin.html';
  }

  @override
  Future<SessionRes> request(
    String url,
    ReqMethod method, {
    Map<String, String>? para,
    data,
    SessionOptions? options,
    SessionProgressCallback? onSendProgress,
    SessionProgressCallback? onReceiveProgress,
  }) async {
    options ??= SessionOptions();
    options.contentType = 'application/x-www-form-urlencoded;charset=utf-8';
    Future<SessionRes> fetch() async {
      return await ssoSession.request(
        url,
        method,
        para: para,
        data: data,
        options: options,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
    }

    var response = await fetch();
    // 如果返回值是登录页面，那就从 SSO 跳转一次以登录.
    if (_isRedirectedToLoginPage(response)) {
      Log.info('EduSession需要登录');
      await _refreshCookie();
      response = await fetch();
    }
    // 如果还是需要登录
    if (_isRedirectedToLoginPage(response)) {
      Log.info('SsoSession需要登录');
      await ssoSession.makeSureLogin(url);
      await _refreshCookie();
      response = await fetch();
    }
    return response;
  }
}
