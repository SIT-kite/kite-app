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

import 'package:kite/abstract/abstract_session.dart';
import 'package:kite/storage/init.dart';
import 'package:kite/util/logger.dart';

class FreshmanSession extends ISession {
  final ISession _session;
  final FreshmanCacheDao _freshmanCacheDao;

  FreshmanSession(this._session, this._freshmanCacheDao) {
    Log.info('初始化 FreshmanSession');
  }

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
    Future<MyResponse> myRequest(
      dynamic data1,
      String url1,
      Map<String, String>? queryParameters1,
    ) async {
      return await _session.request(
        url1,
        method,
        queryParameters: queryParameters1,
        data: data1,
        options: options,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
    }

    // 如果不存在新生信息，那就不管了
    if (_freshmanCacheDao.freshmanAccount == null || _freshmanCacheDao.freshmanSecret == null) {
      return await myRequest(data, url, queryParameters);
    }

    // 新生信息
    String account = _freshmanCacheDao.freshmanAccount!;
    String secret = _freshmanCacheDao.freshmanSecret!;

    final String myUrl = '/freshman/$account$url';

    // 如果是GET请求，登录态直接注入到 queryParameters 中
    if (method == RequestMethod.get) {
      final myQuery = queryParameters ?? {};
      myQuery['secret'] = secret;
      return await myRequest(data, myUrl, myQuery);
    }

    // 其他请求的话，如果data是Map那么注入登录态
    if (data == null || data is Map<String, dynamic>) {
      final Map<String, dynamic> myData = data ?? {};
      myData['account'] = account;
      myData['secret'] = secret;

      // 修改url
      return await myRequest(myData, myUrl, queryParameters);
    }

    // 其他情况不动data,但是url还是得边
    return await myRequest(data, myUrl, queryParameters);
  }
}
