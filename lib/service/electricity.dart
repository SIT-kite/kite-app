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

Future<List<ConditionHours>> fetchConditionHours(String room) async {
  final url = _getElectricityUrl(room, Mode.condition_hours);
  final response = await Dio().get(url);
  List<ConditionHours> list = response.data['data'].map<ConditionHours>((e) => ConditionHours.fromJson(e)).toList();

  return list;
}

Future<List<ConditionDays>> fetchConditionDays(String room) async {
  final url = _getElectricityUrl(room, Mode.condition_days);
  final response = await Dio().get(url);
  List<ConditionDays> list = response.data['data'].map<ConditionDays>((e) => ConditionDays.fromJson(e)).toList();

  return list;
}
