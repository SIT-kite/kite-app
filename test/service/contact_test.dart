import 'package:kite/service/contact.dart';

import 'mock_util.dart';

void main() async {
  await init();
  await login();
  var session = SessionPool.ssoSession;
  test('expense test', () async {
    final contact = await ContactRemoteService(session).getContactData();
    Log.info(contact);
  });
}
