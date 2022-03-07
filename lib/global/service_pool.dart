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
import 'package:kite/dao/index.dart';
import 'package:kite/domain/edu/init.dart';
import 'package:kite/domain/library/init.dart';
import 'package:kite/service/index.dart';

import 'session_pool.dart';

/// 网络服务请求池
class ServicePool {
  static late BulletinDao bulletin;
  static late CampusCardDao campusCard;
  static late ExpenseRemoteDao expenseRemote;
  static late WeatherDao weather;
  static late ContactRemoteDao contactData;

  /// 初始化其他service
  static void _initOther() {
    bulletin = BulletinService(SessionPool.ssoSession);
    campusCard = CampusCardService(SessionPool.ssoSession);
    expenseRemote = ExpenseRemoteService(SessionPool.ssoSession);
    contactData = ContactRemoteService(SessionPool.ssoSession);
    weather = WeatherService();
  }

  static void init() {
    LibraryInitializer.init(SessionPool.librarySession);
    EduInitializer.init(SessionPool.eduSession);
    _initOther();
  }
}
