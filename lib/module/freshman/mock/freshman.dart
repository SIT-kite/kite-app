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
import 'dart:convert';

import '../dao/Freshman.dart';
import '../entity/info.dart';
import '../entity/relationship.dart';
import '../entity/statistics.dart';

class FreshmanMock implements FreshmanDao {
  @override
  Future<FreshmanInfo> getInfo() async {
    String json = '''
  {
    "name": "姓名",
    "uid": 100,
    "studentId": "学号",
    "college": "学院",
    "major": "专业",
    "campus": "奉贤校区",
    "building": "xx号楼",
    "room": 111,
    "bed": "111-01",
    "counselorName": "辅导员姓名",
    "counselorTel": "手机号或固话",
    "visible": false
  }
  ''';
    FreshmanInfo f = FreshmanInfo.fromJson(jsonDecode(json));
    return f;
  }

  @override
  Future<Analysis> getAnalysis() {
    // TODO: implement getAnalysis
    throw UnimplementedError();
  }

  @override
  Future<List<Mate>> getClassmates() {
    // TODO: implement getClassmates
    throw UnimplementedError();
  }

  @override
  Future<List<Familiar>> getFamiliars() {
    // TODO: implement getFamiliars
    throw UnimplementedError();
  }

  @override
  Future<List<Mate>> getRoommates() {
    // TODO: implement getRoommates
    throw UnimplementedError();
  }

  @override
  Future<void> postAnalysisLog() {
    // TODO: implement postAnalysisLog
    throw UnimplementedError();
  }

  @override
  Future<void> update({Contact? contact, bool? visible}) {
    // TODO: implement update
    throw UnimplementedError();
  }
}
