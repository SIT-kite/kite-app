import 'package:kite/entity/electricity.dart';

// 本地存储
abstract class ElectricityStorageDao {
  String? get lastBuilding;

  set lastBuilding(String? building);

  String? get lastRoom;

  set lastRoom(String? room);
}

// 远程
abstract class ElectricityServiceDao {
  // 获取电费数据
  Future<Balance> getBalance(String room);

  // 获取排名数据
  Future<Rank> getRank(String room);

  // 获取按小时用电记录
  Future<List<HourlyBill>> getHourlyBill(String room);

  // 获取按天用电记录
  Future<List<DailyBill>> getDailyBill(String room);
}
