/*
 *    上应小风筝(SIT-kite)  便利校园，一步到位
 *    Copyright (C) 2022 上海应用技术大学 上应小风筝团队
 *
 *    This program is free software: you can redistribute it and/or modify
 *    it under the terms of the GNU General Public License as published by
 *    the Free Software Foundation, either version 3 of the License, or
 *    (at your option) any later version.
 *
 *    This program is distributed in the hope that it will be useful,
 *    but WITHOUT ANY WARRANTY; without even the implied warranty of
 *    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *    GNU General Public License for more details.
 *
 *    You should have received a copy of the GNU General Public License
 *    along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/
import '../entity/exam.dart';
import '../storage/exam.dart';

import '../dao/exam.dart';
import '../using.dart';

class ExamCache extends ExamDao {
  final ExamDao from;
  final ExamStorage to;
  Duration expiration;

  ExamCache({
    required this.from,
    required this.to,
    this.expiration = const Duration(minutes: 10),
  });

  @override
  Future<List<ExamEntry>?> getExamList(SchoolYear schoolYear, Semester semester) async {
    final cacheKey = to.box.exams.make(ExamStorage.makeExamsKey(schoolYear, semester));
    if (cacheKey.needRefresh(after: expiration)) {
      final res = await from.getExamList(schoolYear, semester);
      to.setExamList(schoolYear, semester, res);
      return res;
    } else {
      return to.getExamList(schoolYear, semester);
    }
  }
}
