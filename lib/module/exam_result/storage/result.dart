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
import '../using.dart';

class _Key {
  static const ns = "/examResult";
  static const resultDetails = "$ns/resultDetails";
  static const results = "$ns/results";
}

class ExamResultStorageBox with CachedBox {
  @override
  final Box<dynamic> box;
  late final results = ListNamespace2<ExamResult, SchoolYear, Semester>(_Key.results, makeResultKey);
  late final resultDetails =
      ListNamespace3<ExamResultDetail, String, SchoolYear, Semester>(_Key.resultDetails, makeResultDetailKey);

  String makeResultKey(SchoolYear schoolYear, Semester semester) => "$schoolYear/$semester";

  String makeResultDetailKey(String classId, SchoolYear schoolYear, Semester semester) =>
      "$classId/$schoolYear/$semester";

  ExamResultStorageBox(this.box);
}

class ExamResultStorage implements ExamResultDao {
  final ExamResultStorageBox box;

  ExamResultStorage(Box<dynamic> hive) : box = ExamResultStorageBox(hive);

  @override
  Future<List<ExamResult>?> getResultList(SchoolYear schoolYear, Semester semester) async {
    final cacheKey = box.results.make(schoolYear, semester);
    return cacheKey.value;
  }

  @override
  Future<List<ExamResultDetail>?> getResultDetail(String classId, SchoolYear schoolYear, Semester semester) async {
    final cacheKey = box.resultDetails.make(classId, schoolYear, semester);
    return cacheKey.value;
  }

  void setResultList(SchoolYear schoolYear, Semester semester, List<ExamResult>? results) {
    final cacheKey = box.results.make(schoolYear, semester);
    cacheKey.value = results;
  }

  void setResultDetail(String classId, SchoolYear schoolYear, Semester semester, List<ExamResultDetail>? detail) {
    final cacheKey = box.resultDetails.make(classId, schoolYear, semester);
    cacheKey.value = detail;
  }
}
