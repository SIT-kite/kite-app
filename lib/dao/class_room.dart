import 'package:kite/entity/class_room.dart';

///远程的常用电话数据访问层的接口
abstract class ClassRoomRomoteDao {
  Future<List<ClassRoomData>> getClassRoomData(String campus, String date);
}
