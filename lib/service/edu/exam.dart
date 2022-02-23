import 'package:kite/dao/edu/index.dart';
import 'package:kite/entity/edu/index.dart';
import 'package:kite/service/abstract_service.dart';
import 'package:kite/session/abstract_session.dart';

import 'util.dart';

class ExamService extends AService implements ExamDao {
  static const _examRoomUrl = 'http://jwxt.sit.edu.cn/jwglxt/kwgl/kscx_cxXsksxxIndex.html';

  ExamService(ASession session) : super(session);

  /// 获取考场信息
  @override
  Future<List<ExamRoom>> getExamList(SchoolYear schoolYear, Semester semester) async {
    var response = await session.post(
      _examRoomUrl,
      queryParameters: {
        'doType': 'query',
        'gnmkdm': 'N358105',
      },
      data: {
        // 学年名
        'xnm': schoolYear.toString(),
        // 学期名
        'xqm': semesterToFormField(semester),
      },
    );
    final List<dynamic> itemsData = response.data['items'];

    return itemsData.map((e) => ExamRoom.fromJson(e as Map<String, dynamic>)).toList();
  }
}
