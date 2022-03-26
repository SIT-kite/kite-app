import 'package:kite/feature/initializer_index.dart';
import 'package:kite/mock/index.dart';
import 'package:kite/setting/init.dart';

void main() async {
  await init();
  test('kite login', () async {
    final profile = await KiteInitializer.kiteSession.login(username, ssoPassword);
    Log.info(profile);
    Log.info(SettingInitializer.jwt.jwtToken);
  });
}
