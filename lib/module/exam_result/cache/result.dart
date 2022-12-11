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
import '../dao/result.dart';
import '../entity/result.dart';
import '../storage/result.dart';
import '../using.dart';

class ExamResultCache implements ExamResultDao {
  final ExamResultDao from;
  final ExamResultStorage to;
  Duration detailExpire;
  Duration listExpire;

  ExamResultCache({
    required this.from,
    required this.to,
    this.detailExpire = const Duration(minutes: 10),
    this.listExpire = const Duration(minutes: 10),
  });

  @override
  Future<List<ExamResult>?> getResultList(SchoolYear schoolYear, Semester semester) async {
    final cacheKey = to.box.results.make(schoolYear, semester);
    if (cacheKey.needRefresh(after: listExpire)) {
      try {
        final res = await from.getResultList(schoolYear, semester);
        to.setResultList(schoolYear, semester, res);
        return res;
      } catch (e) {
        return to.getResultList(schoolYear, semester);
      }
    } else {
      return to.getResultList(schoolYear, semester);
    }
  }

  @override
  Future<List<ExamResultDetail>?> getResultDetail(String classId, SchoolYear schoolYear, Semester semester) async {
    final cacheKey = to.box.resultDetails.make(classId, schoolYear, semester);
    if (cacheKey.needRefresh(after: listExpire)) {
      try {
        final res = await from.getResultDetail(classId, schoolYear, semester);
        to.setResultDetail(classId, schoolYear, semester, res);
        return res;
      } catch (e) {
        return to.getResultDetail(classId, schoolYear, semester);
      }
    } else {
      return to.getResultDetail(classId, schoolYear, semester);
    }
  }
}
