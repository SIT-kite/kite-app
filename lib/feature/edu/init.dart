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

import 'package:cookie_jar/cookie_jar.dart';
import 'package:hive/hive.dart';
import 'package:kite/feature/edu/exam/init.dart';
import 'package:kite/feature/edu/score/init.dart';
import 'package:kite/feature/edu/timetable/init.dart';
import 'package:kite/session/kite_session.dart';
import 'package:kite/session/sso/index.dart';

import '../../session/edu_session.dart';

class EduInitializer {
  static late CookieJar cookieJar;

  /// 初始化教务相关的service
  static Future<void> init({
    required SsoSession ssoSession,
    required CookieJar cookieJar,
    required KiteSession kiteSession,
    required Box<dynamic> timetableBox,
  }) async {
    EduInitializer.cookieJar = cookieJar;

    final eduSession = EduSession(ssoSession);
    ExamInitializer.init(eduSession);
    ScoreInitializer.init(eduSession);

    TimetableInitializer.init(
      eduSession: eduSession,
      kiteSession: kiteSession,
      timetableBox: timetableBox,
    );
  }
}
