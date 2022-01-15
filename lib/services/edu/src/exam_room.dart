import 'package:kite/services/abstract_session.dart';
import 'package:kite/services/edu/edu.dart';
import 'package:kite/services/edu/src/exam_room_parser.dart';

class ExamRoomService {
  static const _examRoomUrl =
      'http://http://jwxt.sit.edu.cn/jwglxt/kwgl/kscx_cxXsksxxIndex.html';

  final ASession _session;

  const ExamRoomService(this._session);

  static String _semesterToRequestField(Semester semester) {
    return {
      Semester.all: '',
      Semester.firstTerm: '3',
      Semester.secondTerm: '12',
      Semester.midTerm: '16',
    }[semester]!;
  }

  /// 获取考场信息
  Future<List<ExamRoom>> getExamRoomList(
    SchoolYear schoolYear,
    Semester semester,
  ) async {
    var response = await _session.post(
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
