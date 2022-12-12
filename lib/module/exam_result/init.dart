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
import 'cache/result.dart';
import 'events.dart';
import 'storage/result.dart';
import 'using.dart';
import 'dao/evaluation.dart';
import 'dao/result.dart';
import 'service/evaluation.dart';
import 'service/result.dart';

class ExamResultInit {
  static late CookieJar cookieJar;
  static late ExamResultDao resultService;
  static late CourseEvaluationDao courseEvaluationService;

  static Future<void> init({
    required CookieJar cookieJar,
    required ISession eduSession,
    required Box<dynamic> box,
  }) async {
    ExamResultInit.cookieJar = cookieJar;
    final examResultCache = ExamResultCache(
      from: ScoreService(eduSession),
      to: ExamResultStorage(box),
      detailExpire: const Duration(days: 180),
      listExpire: const Duration(hours: 6),
    );
    resultService = examResultCache;
    courseEvaluationService = CourseEvaluationService(eduSession);
    eventBus.on<LessonEvaluatedEvent>().listen((event) {
      examResultCache.clearResultListCache();
    });
  }
}
