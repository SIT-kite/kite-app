// 本地存储
abstract class ElectricityStorageDao {
  List<String>? get lastRoomList;

  set lastRoomList(List<String>? room);
}
