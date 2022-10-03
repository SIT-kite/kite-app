import 'package:kite/module/initializer_index.dart';
import 'package:kite/mock/index.dart';
import 'package:kite/storage/init.dart';

void main() async {
  await init();
  test('kite login', () async {
    final profile = await KiteInitializer.kiteSession.login(username, ssoPassword);
    Log.info(profile);
    Log.info(Kv.jwt.jwtToken);
  });
}
