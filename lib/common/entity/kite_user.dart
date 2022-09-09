import 'package:json_annotation/json_annotation.dart';

part 'kite_user.g.dart';

@JsonSerializable()
class KiteUser {
  int uid = 0;
  String account = '';
  DateTime createTime = DateTime.now();
  int role = 0;
  bool isBlock = false;

  KiteUser();

  factory KiteUser.fromJson(Map<String, dynamic> json) => _$KiteUserFromJson(json);

  Map<String, dynamic> toJson() => _$KiteUserToJson(this);

  @override
  String toString() {
    return 'KiteUser{uid: $uid, account: $account, createTime: $createTime, role: $role, isBlock: $isBlock}';
  }
}
