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

import '../../session/sc_session.dart';
import 'dao/index.dart';
import 'dao/list.dart';
import 'service/index.dart';

class ScInitializer {
  static late ScSession session;
  static late ScActivityListDao scActivityListService;
  static late ScActivityDetailDao scActivityDetailService;
  static late ScJoinActivityDao scJoinActivityService;
  static late ScScoreDao scScoreService;

  static void init({
    required ISession ssoSession,
  }) {
    session = ScSession(ssoSession);
    scActivityListService = ScActivityListService(session);
    scActivityDetailService = ScActivityDetailService(session);
    scJoinActivityService = ScJoinActivityService(session);
    scScoreService = ScScoreService(session);
  }
}
