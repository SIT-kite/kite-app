import 'package:hive/hive.dart';

part 'auth_item.g.dart';

/// 用于存放认证信息
@HiveType(typeId: 2)
class AuthItem extends HiveObject {
  @HiveField(0, defaultValue: '')
  String username = '';

  @HiveField(1, defaultValue: '')
  String password = '';
}
