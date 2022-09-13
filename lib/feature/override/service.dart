import 'package:kite/abstract/abstract_service.dart';
import 'package:kite/abstract/abstract_session.dart';

import 'entity.dart';
import 'interface.dart';

class FunctionOverrideService extends AService implements FunctionOverrideServiceDao {
  FunctionOverrideService(super.session);

  @override
  Future<FunctionOverrideInfo> get() async {
    final response = await session.request('https://kite.sunnysab.cn/override.json', RequestMethod.get);
    return FunctionOverrideInfo.fromJson(response.data);
  }
}
