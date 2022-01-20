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
  double balance;
  double power;
  String ts;

  Balance(this.balance, this.power, this.ts);

  factory Balance.fromJson(Map<String, dynamic> json) =>
      _$BalanceFromJson(json);
}

@JsonSerializable()
class Rank {
  double consumption;
  int rank;
  int roomCount;

  Rank(this.consumption, this.rank, this.roomCount);

  factory Rank.fromJson(Map<String, dynamic> json) =>
      _$RankFromJson(json);
}

@JsonSerializable()
class ConditionHours {
  double charge;
  double consumption;
  String time;

  ConditionHours(this.charge, this.consumption, this.time);

  factory ConditionHours.fromJson(Map<String, dynamic> json) =>
      _$ConditionHoursFromJson(json);
}

@JsonSerializable()
class ConditionDays {
  double charge;
  double consumption;
  String date;

  ConditionDays(this.charge, this.consumption, this.date);

  factory ConditionDays.fromJson(Map<String, dynamic> json) =>
      _$ConditionDaysFromJson(json);
}
