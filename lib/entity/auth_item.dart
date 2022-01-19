import 'package:hive/hive.dart';
import 'package:kite/global/hive_type_id_pool.dart';

part 'auth_item.g.dart';

/// 用于存放认证信息
@HiveType(typeId: HiveTypeIdPool.authItemTypeId)
class AuthItem extends HiveObject {
  @HiveField(0, defaultValue: '')
  String username = '';

  @HiveField(1, defaultValue: '')
  String password = '';
}
