import 'package:kite/dao/electricity.dart';
import 'package:kite/entity/electricity.dart';
import 'package:kite/service/abstract_service.dart';
import 'package:kite/service/abstract_session.dart';

class ElectricityService extends AService implements ElectricityServiceDao {
  static const String _baseUrl = 'https://kite.sunnysab.cn/api/v2/electricity/room';

  ElectricityService(ASession session) : super(session);

  @override
  Future<Balance> getBalance(String room) async {
    final response = await session.get('$_baseUrl/$room');
    Balance balance = Balance.fromJson(response.data['data']);

    return balance;
  }

  @override
  Future<List<DailyBill>> getDailyBill(String room) async {
    final response = await session.get('$_baseUrl/$room/bill/days');
    List<DailyBill> list = response.data['data'].map<DailyBill>(DailyBill.fromJson).toList();

    return list;
  }

  @override
  Future<List<HourlyBill>> getHourlyBill(String room) async {
    final response = await session.get('$_baseUrl/$room/bill/hours');
    List<HourlyBill> list = response.data['data'].map<HourlyBill>(HourlyBill.fromJson).toList();

    return list;
  }

  @override
  Future<Rank> getRank(String room) async {
    final response = await session.get('$_baseUrl/$room/rank');
    final rank = Rank.fromJson(response.data['data']);

    return rank;
  }
}
