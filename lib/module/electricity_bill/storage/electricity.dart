import 'package:hive/hive.dart';

import '../dao/local.dart';

class ElectricityStorage implements ElectricityStorageDao {
  final Box<dynamic> box;

  ElectricityStorage(this.box);

  @override
  List<String>? get lastRoomList => box.get('/lastRoomList');

  @override
  set lastRoomList(List<String>? roomList) => box.put('/lastRoomList', roomList);
}
