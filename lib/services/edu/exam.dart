import 'dart:convert';

import 'package:kite/entity/edu.dart';
import 'package:kite/services/abstract_service.dart';
import 'package:kite/services/abstract_session.dart';

class ExamRoomService extends AService {
  static const _examRoomUrl = 'http://http://jwxt.sit.edu.cn/jwglxt/kwgl/kscx_cxXsksxxIndex.html';

  ExamRoomService(ASession session) : super(session);

  static String _semesterToRequestField(Semester semester) {
    return {
      Semester.all: '',
      Semester.firstTerm: '3',
      Semester.secondTerm: '12',
    }[semester]!;
  }

  List<ExamRoom> parseExamRoomPage(String page) {
    var jsonPage = jsonDecode(page);
    List<ExamRoom> result = [];
    for (var examRoom in jsonPage["items"]) {
      ExamRoom newExamRoom = ExamRoom.fromJson(examRoom);
      result.add(newExamRoom);
    }
    return result;
  }

  /// 获取考场信息
  Future<List<ExamRoom>> getExamRoomList(
    SchoolYear schoolYear,
    Semester semester,
  ) async {
    var response = await session.post(
      _examRoomUrl,
      queryParameters: {
        'gnmkdm': 'N358105',
        // 实测以下被注释的字段根本无用，又提高了耦合
        // 'su': _session.username!,
      },
      data: {
        // 学年名
        'xnm': schoolYear.toString(),
        // 学期名
        'xqm': _semesterToRequestField(semester),
      },
    );
    return parseExamRoomPage(response.data);
  }
}
