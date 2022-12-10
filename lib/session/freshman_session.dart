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

import 'package:kite/credential/symbol.dart';
import 'package:kite/network/session.dart';
import 'package:kite/storage/init.dart';
import 'package:kite/util/logger.dart';

class FreshmanSession extends ISession {
  final ISession _session;
  final FreshmanCacheDao _freshmanCacheDao;

  FreshmanSession(this._session, this._freshmanCacheDao) {
    Log.info('初始化 FreshmanSession');
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
    Future<SessionRes> myRequest(
      dynamic data1,
      String url1,
      Map<String, String>? queryParameters1,
    ) async {
      return await _session.request(
        url1,
        method,
        para: queryParameters1,
        data: data1,
        options: options,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
    }
    final freshmanCredential = Auth.freshmanCredential;
    // 如果不存在新生信息，那就不管了
    // TODO: WHAT ???
    if (freshmanCredential == null) {
      return await myRequest(data, url, para);
    }

    // 新生信息
    String account = freshmanCredential.account;
    String secret = freshmanCredential.password;

    final String myUrl = '/freshman/$account$url';

    // 如果是GET请求，登录态直接注入到 queryParameters 中
    if (method == ReqMethod.get) {
      final myQuery = para ?? {};
      myQuery['secret'] = secret;
      return await myRequest(data, myUrl, myQuery);
    }

    // 其他请求的话，如果data是Map那么注入登录态
    if (data == null || data is Map<String, dynamic>) {
      final Map<String, dynamic> myData = data ?? {};
      myData['account'] = account;
      myData['secret'] = secret;

      // 修改url
      return await myRequest(myData, myUrl, para);
    }

    // 其他情况不动data,但是url还是得边
    return await myRequest(data, myUrl, para);
  }
}
