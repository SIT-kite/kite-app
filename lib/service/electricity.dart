import 'package:dio/dio.dart';
import 'package:kite/entity/electricity.dart';


// TODO: 错误处理
String _getElectricityUrl(String room, Mode mode) {
  String url = 'https://kite.sunnysab.cn/api/v2/electricity/room/';
  switch (mode) {
    case Mode.balance:
      url += '$room';break;
    case Mode.rank:
      url += '$room/rank';break;
    case Mode.condition_hours:
      url += '$room/bill/hours';break;
    case Mode.condition_days:
      url += '$room/bill/days';break;
  }
  return url;
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

Future<List<ConditionHours>> fetchCondition(String room, Mode mode) async {
  final url = _getElectricityUrl(room, mode);
  final response = await Dio().get(url);
  final list = response.data['data'].map((e) => ConditionHours.fromJson(e));

  return list;
}
