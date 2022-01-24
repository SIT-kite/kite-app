import 'package:kite/dao/edu/evaluation.dart';
import 'package:kite/entity/edu/evaluation.dart';
import 'package:kite/service/abstract_service.dart';
import 'package:kite/session/abstract_session.dart';

class CourseEvaluationService extends AService implements CourseEvaluationDao {
  static const _serviceUrl = 'http://jwxt.sit.edu.cn/jwglxt/xspjgl/xspj_cxXspjIndex.html?doType=query&gnmkdm=N401605';

  CourseEvaluationService(ASession session) : super(session);

  List<CourseToEvaluate> _parseEvaluationList(Map<String, dynamic> page) {
    final List evaluationList = page['items'];

    return evaluationList.map((e) => CourseToEvaluate.fromJson(e as Map<String, dynamic>)).toList();
  }

  @override
  Future<List<CourseToEvaluate>> getEvaluationList() async {
    final Map form = {
      '_search': 'false',
      'queryModel.showCount': 100,
      'queryModel.currentPage': '1',
      'queryModel.sortName': '',
      'queryModel.sortOrder': 'asc',
      'time': 0
    };

    final response = await session.post(_serviceUrl, data: form);
    return _parseEvaluationList(response.data);
  }
}
