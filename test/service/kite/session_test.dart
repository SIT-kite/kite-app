import '../mock_util.dart';

void main() async {
  await init();
  test('kite login', () async {
    final profile = await SessionPool.kiteSession.login(username + '1', password);
    Log.info(profile);
    Log.info(StoragePool.jwt.jwtToken);
  });
}
