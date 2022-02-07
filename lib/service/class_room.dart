import 'package:kite/session/abstract_session.dart';
import 'package:kite/service/abstract_service.dart';
import 'package:kite/dao/class_room.dart';
import 'package:kite/entity/class_room.dart';

class ClassRoomRomoteService extends AService implements ClassRoomRomoteDao {
  static const _classRoomUrl =
      "https://kite.sunnysab.cn/api/v2/classroom/available";

  ClassRoomRomoteService(ASession session) : super(session);
  @override
  Future<List<ClassRoomData>> getClassRoomData(
      String campus, String date) async {
    print("object");
    final response_first;
    final response_second;
    if (campus == '奉贤校区') {
      response_first =
          await session.get('$_classRoomUrl?campus=1&date=$date&building=一教');
      response_second =
          await session.get('$_classRoomUrl?campus=1&date=$date&building=二教');
    } else {
      response_first =
          await session.get('$_classRoomUrl?campus=2&date=$date&building=教学楼');
      response_second =
          await session.get('$_classRoomUrl?campus=1&date=$date&building=南图');
    }

    final List classRooomDataList = response_first.data['data'];
    List<ClassRoomData> result =
        classRooomDataList.map((e) => ClassRoomData.fromJson(e)).toList();
    print(result);
    return result;
  }
}
