import 'package:kite/service/class_room.dart';

import 'mock_util.dart';

void main() async {
  await init();
  await login();
  var session = SessionPool.ssoSession;
  test('class_room test', () async {
    final class_room = await ClassRoomRomoteService(session)
        .getClassRoomData('1', '2021-12-7');
    Log.info(class_room);
  });
}
