import 'package:json_annotation/json_annotation.dart';

part 'account.g.dart';

@JsonSerializable(createToJson: false)
class KiteUser {
  int uid = 0;
  String account = '';
  DateTime createTime = DateTime.now();
  int role = 0;
  bool isBlock = false;
  factory KiteUser.fromJson(Map<String, dynamic> json) => _$KiteUserFromJson(json);
}
