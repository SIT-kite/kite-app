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

import 'package:kite/dao/edu/index.dart';
import 'package:kite/entity/edu/index.dart';
import 'package:kite/service/abstract_service.dart';
import 'package:kite/session/abstract_session.dart';

import 'util.dart';

class ExamService extends AService implements ExamDao {
  static const _examRoomUrl = 'http://http://jwxt.sit.edu.cn/jwglxt/kwgl/kscx_cxXsksxxIndex.html';

  ExamService(ASession session) : super(session);

  List<ExamRoom> _parseExamRoomPage(String page) {
    final List<Map<String, dynamic>> examList = jsonDecode(page)['items'];

    return examList.map(ExamRoom.fromJson).toList();
  }

  /// 获取考场信息
  @override
  Future<List<ExamRoom>> getExamList(SchoolYear schoolYear, Semester semester) async {
    var response = await session.post(
      _examRoomUrl,
      queryParameters: {'gnmkdm': 'N358105'},
      data: {
        // 学年名
        'xnm': schoolYear.toString(),
        // 学期名
        'xqm': semesterToFormField(semester),
      },
    );
    return _parseExamRoomPage(response.data);
  }
}
