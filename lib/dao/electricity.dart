import 'package:kite/entity/electricity.dart';

abstract class ElectricityStorageDao {
  String? get lastBuilding;

  set lastBuilding(String? building);

  String? get lastRoom;

  set lastRoom(String? room);
}

abstract class ElectricityServiceDao {
  Future<Balance> getBalance(String room);

  Future<Rank> getRank(String room);

  Future<List<HourlyBill>> getHourlyBill(String room);

  Future<List<DailyBill>> getDailyBill(String room);
}
