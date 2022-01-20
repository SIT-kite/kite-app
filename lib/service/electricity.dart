import 'package:dio/dio.dart';
import 'package:kite/entity/electricity.dart';


// TODO: 错误处理
String _getElectricityUrl(String room, Mode mode) {
  switch (mode) {
    case Mode.balance:
      return 'https://kite.sunnysab.cn/api/v2/electricity/room/$room';
    case Mode.rank:
      return 'https://kite.sunnysab.cn/api/v2/electricity/room/$room/rank';
    case Mode.condition_hours:
      return 'https://kite.sunnysab.cn/api/v2/electricity/room/$room/bill/hours';
    case Mode.condition_days:
      return 'https://kite.sunnysab.cn/api/v2/electricity/room/$room/bill/days';
  }
}

Future<Balance> fetchBalance(String room) async {
  final url = _getElectricityUrl(room, Mode.balance);
  final response = await Dio().get(url);
  final balance = Balance.fromJson(response.data['data']);

  return balance;
}

Future<Rank> fetchRank(String room) async {
  final url = _getElectricityUrl(room, Mode.rank);
  final response = await Dio().get(url);
  final rank = Rank.fromJson(response.data['data']);

  return rank;
}

Future<List<ConditionHours>> fetchConditionHours(String room) async {
  final url = _getElectricityUrl(room, Mode.condition_hours);
  final response = await Dio().get(url);
  final list = response.data['data'].map((e) => ConditionHours.fromJson(e));

  return list;
}
