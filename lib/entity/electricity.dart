import 'package:json_annotation/json_annotation.dart';

part 'electricity.g.dart';

enum Mode {
  balance,
  rank,
  condition_hours,
  condition_days,
}

@JsonSerializable()
class Balance {
  @JsonKey(name: 'balance', fromJson: _toBalance)
  // 余额
  double balance = 0.0;
  @JsonKey(name: 'power', fromJson: _toPower)
  // 余量
  double power = 0.0;
  @JsonKey(name: 'room', fromJson: _intToRoom)
  // 房间号
  String room = '';
  @JsonKey(name: 'ts', fromJson: _toTs)
  // 更新时间
  String ts = '';

  Balance();

  factory Balance.fromJson(Map<String, dynamic> json) =>
      _$BalanceFromJson(json);

  @override
  String toString() =>
      'Balance{balance: $balance, course: $power, power: $room, classId: $room, ts: $ts}';

  static double _toBalance(double balance) =>
      double.parse(balance.toStringAsFixed(2));

  static double _toPower(double power) =>
      double.parse(power.toStringAsFixed(2));

  static String _intToRoom(int room) => room.toString();

  static String _toTs(String ts) => ts.replaceAll('T', ' ').substring(0, 16);
}

@JsonSerializable()
class Rank {
  @JsonKey(name: 'consumption', fromJson: _toConsumption)
  // 消费
  double consumption = 0.0;
  @JsonKey(name: 'rank')
  // 排名
  int rank = -1;
  @JsonKey(name: 'roomCount')
  // 房间总数
  int roomCount = -1;

  Rank();

  factory Rank.fromJson(Map<String, dynamic> json) => _$RankFromJson(json);

  @override
  String toString() =>
      'Rank{consumption: $consumption, rank: $rank, roomCount: $roomCount}';

  static double _toConsumption(double consumption) =>
      double.parse(consumption.toStringAsFixed(2));
}

@JsonSerializable()
class ConditionHours {
  @JsonKey(name: 'charge', fromJson: _toCharge)
  // 充值金额
  double charge = 0.0;
  @JsonKey(name: 'consumption', fromJson: _toConsumption)
  // 消费金额
  double consumption = 0.0;
  @JsonKey(name: 'time', fromJson: _toTime)
  // 时间
  String time = '';

  ConditionHours();

  factory ConditionHours.fromJson(Map<String, dynamic> json) =>
      _$ConditionHoursFromJson(json);

  @override
  String toString() =>
      'ConditionHours{charge: $charge, consumption: $consumption, time: $time}';

  static double _toCharge(double charge) =>
      double.parse(charge.toStringAsFixed(2));

  static double _toConsumption(double consumption) =>
      double.parse(consumption.toStringAsFixed(2));

  static String _toTime(String time) => time.substring(11, 13);
}

@JsonSerializable()
class ConditionDays {
  @JsonKey(name: 'charge', fromJson: _toCharge)
  // 充值金额
  double charge = 0.0;
  @JsonKey(name: 'consumption', fromJson: _toConsumption)
  // 消费金额
  double consumption = 0.0;
  @JsonKey(name: 'date', fromJson: _toDate)
  // 日期
  String date = '';

  ConditionDays();

  factory ConditionDays.fromJson(Map<String, dynamic> json) =>
      _$ConditionDaysFromJson(json);

  @override
  String toString() =>
      'ConditionDays{charge: $charge, consumption: $consumption, date: $date}';

  static double _toCharge(double charge) =>
      double.parse(charge.toStringAsFixed(2));

  static double _toConsumption(double consumption) =>
      double.parse(consumption.toStringAsFixed(2));

  static String _toDate(String time) => time.substring(8, 10);
}
