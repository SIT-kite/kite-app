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
import 'package:kite/global/session_pool.dart';

/// 检查网络连接情况
Future<bool> checkConnectivity() async {
  try {
    await SessionPool.ssoSession.get(
      'http://jwxt.sit.edu.cn/',
      options: Options(
        followRedirects: false,
        sendTimeout: 3,
        receiveTimeout: 3,
        validateStatus: (code) => true,
      ),
    );
    return true;
  } catch (e) {
    return false;
  }
}
