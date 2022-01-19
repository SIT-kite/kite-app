import 'dart:convert';

import 'package:kite/dao/edu.dart';
import 'package:kite/entity/edu.dart';
import 'package:kite/service/abstract_service.dart';
import 'package:kite/service/abstract_session.dart';

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
