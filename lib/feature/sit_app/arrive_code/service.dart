import 'package:kite/abstract/abstract_service.dart';
import 'package:kite/abstract/abstract_session.dart';

import 'dao.dart';

class ArriveCodeService extends AService implements ArriveCodeDao {
  ArriveCodeService(ASession session) : super(session);

  @override
  Future<String> arrive(String code) async {
    final response = await session.post(
      'https://xgfy.sit.edu.cn//regist/scan/appAdd',
      data: {'place': code},
    );
    return response.data['msg'];
  }
}
