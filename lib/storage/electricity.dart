import 'package:hive/hive.dart';
import 'package:kite/dao/electricity.dart';

class ElectricityStorage implements ElectricityStorageDao {
  final Box<dynamic> box;

  const ElectricityStorage(this.box);

  @override
  String? get lastBuilding => box.get('/building');

  @override
  set lastBuilding(String? building) => box.put('/building', building);

  @override
  String? get lastRoom => box.get('/room');

  @override
  set lastRoom(String? room) => box.put('/room', room);
}
