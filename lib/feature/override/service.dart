import 'package:kite/network/session.dart';
import 'package:kite/util/logger.dart';

import 'entity.dart';
import 'interface.dart';

class FunctionOverrideService implements FunctionOverrideServiceDao {
  final ISession session;

  const FunctionOverrideService(this.session);

  @override
  Future<FunctionOverrideInfo> get() async {
    Log.info('获取拉取动态路由配置');
    final response = await session.request('https://kite.sunnysab.cn/override.json', ReqMethod.get);
    return FunctionOverrideInfo.fromJson(response.data);
  }
}
