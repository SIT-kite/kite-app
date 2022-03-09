import 'package:kite/setting/init.dart';

import '../mock_util.dart';

void main() async {
  await init();
  test('kite login', () async {
    final profile = await SessionPool.kiteSession.login(username, ssoPassword);
    Log.info(profile);
    Log.info(SettingInitializer.jwt.jwtToken);
  });
}
