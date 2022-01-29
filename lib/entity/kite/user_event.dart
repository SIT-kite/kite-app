import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_event.g.dart';

@HiveType(typeId: 10)
enum UserEventType {
  @HiveField(0)
  page,
  @HiveField(1)
  startup,
  @HiveField(2)
  exit,
  @HiveField(3)
  button,
}

/// 用户行为类
@HiveType(typeId: 11)
@JsonSerializable()
class UserEvent {
  /// 时间
  @HiveField(0)
  late final DateTime ts;

  /// 类型
  @HiveField(1)
  @JsonKey(toJson: userEventTypeIndex)
  final UserEventType type;

  /// 参数
  @HiveField(2)
  final Map<String, dynamic> params;

  UserEvent(this.type, this.params) {
    ts = DateTime.now();
  }

  Map<String, dynamic> toJson() => _$UserEventToJson(this);
}

int userEventTypeIndex(UserEventType type) => type.index;
