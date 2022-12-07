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
import 'package:kite/cache/box.dart';

import '../dao/exam.dart';
import '../entity/exam.dart';
import '../using.dart';

class ExamStorageBox with CachedBox {
  static const _examArrangementNs = "/exam_arr";
  @override
  final Box box;
  late final exams = Namespace<List<ExamEntry>>(_examArrangementNs);

  ExamStorageBox(this.box);
}

class ExamStorage extends ExamDao {
  final ExamStorageBox box;

  ExamStorage(Box<dynamic> hive) : box = ExamStorageBox(hive);

  static String makeExamsKey(SchoolYear schoolYear, Semester semester) {
    return "$schoolYear/$semester";
  }

  @override
  Future<List<ExamEntry>> getExamList(SchoolYear schoolYear, Semester semester) async {
    final cacheKey = box.exams.make(makeExamsKey(schoolYear, semester));
    return cacheKey.value ?? [];
  }

  void setExamList(SchoolYear schoolYear, Semester semester, List<ExamEntry> exams) {
    final cacheKey = box.exams.make(makeExamsKey(schoolYear, semester));
    cacheKey.value = exams;
  }
}
