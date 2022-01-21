import 'package:dio/dio.dart';
import 'package:kite/entity/electricity.dart';

// TODO: 错误处理
String _getElectricityUrl(String room, Mode mode) {
  String url = 'https://kite.sunnysab.cn/api/v2/electricity/room/';
  switch (mode) {
    case Mode.balance:
      url += room;
      break;
    case Mode.rank:
      url += '$room/rank';
      break;
    case Mode.conditionHours:
      url += '$room/bill/hours';
      break;
    case Mode.conditionDays:
      url += '$room/bill/days';
      break;
  }
  return url;
}

Future<Balance> fetchBalance(String room) async {
  final url = _getElectricityUrl(room, Mode.balance);
  final response = await Dio().get(url);
  Balance balance;
  try {
    balance = Balance.fromJson(response.data['data']);
  } catch (e) {
    balance = Balance();
  }

  return balance;
}

Future<Rank> fetchRank(String room) async {
  final url = _getElectricityUrl(room, Mode.rank);
  final response = await Dio().get(url);
  final rank = Rank.fromJson(response.data['data']);

  return rank;
}

Future<List<ConditionHours>> fetchConditionHours(String room) async {
  final url = _getElectricityUrl(room, Mode.conditionHours);
  final response = await Dio().get(url);
  List<ConditionHours> list = response.data['data'].map<ConditionHours>((e) => ConditionHours.fromJson(e)).toList();

  return list;
}

Future<List<ConditionDays>> fetchConditionDays(String room) async {
  final url = _getElectricityUrl(room, Mode.conditionDays);
  final response = await Dio().get(url);
  List<ConditionDays> list = response.data['data'].map<ConditionDays>((e) => ConditionDays.fromJson(e)).toList();

  return list;
}
