import 'package:hive/hive.dart';
import 'package:kite/dao/setting/auth.dart';
import 'package:kite/storage/setting/constants.dart';

class AuthSettingStorage implements AuthSettingDao {
  final Box<dynamic> box;
  AuthSettingStorage(this.box);
  @override
  String? get currentUsername => box.get(SettingKeyConstants.authCurrentUsername);

  @override
  set currentUsername(String? foo) => box.put(SettingKeyConstants.authCurrentUsername, foo);
}
