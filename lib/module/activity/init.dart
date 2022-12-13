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

import 'package:hive/hive.dart';
import 'package:kite/network/session.dart';

import '../../session/sc_session.dart';
import 'cache/detail.dart';
import 'cache/list.dart';
import 'cache/score.dart';
import 'dao/detail.dart';
import 'dao/list.dart';
import 'dao/score.dart';
import 'service/detail.dart';
import 'service/join.dart';
import 'service/list.dart';
import 'service/score.dart';
import 'storage/detail.dart';
import 'storage/list.dart';
import 'storage/score.dart';

class ScInit {
  static late ScSession session;
  static late ScActivityListDao scActivityListService;
  static late ScActivityDetailDao scActivityDetailService;
  static late ScScoreDao scScoreService;
  static late ScJoinActivityService scJoinActivityService;

  static void init({
    required ISession ssoSession,
    required Box<dynamic> box,
  }) {
    session = ScSession(ssoSession);
    scActivityListService = ScActivityListCache(
      from: ScActivityListService(session),
      to: ScActivityListStorage(box),
      expiration: const Duration(minutes: 30),
    );
    scActivityDetailService = ScActivityDetailCache(
      from: ScActivityDetailService(session),
      to: ScActivityDetailStorage(box),
      expiration: const Duration(days: 180),
    );
    scScoreService = ScScoreCache(
      from: ScScoreService(session),
      to: ScScoreStorage(box),
      expiration: const Duration(minutes: 5),
    );
    scJoinActivityService = ScJoinActivityService(session);
  }
}
