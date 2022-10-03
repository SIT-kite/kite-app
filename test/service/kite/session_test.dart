import 'package:kite/mock/index.dart';
import 'package:kite/module/symbol.dart';
import 'package:kite/storage/init.dart';

void main() async {
  await init();
  test('kite login', () async {
    final profile = await SharedInitializer.kiteSession.login(username, ssoPassword);
    Log.info(profile);
    Log.info(Kv.jwt.jwtToken);
  });
}
