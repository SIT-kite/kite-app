import 'package:hive/hive.dart';
import 'package:kite/dao/setting/network.dart';
import 'package:kite/storage/constants.dart';

class NetworkSettingStorage implements NetworkSettingDao {
  final Box<dynamic> box;

  NetworkSettingStorage(this.box);

  @override
  String get proxy => box.get(SettingKeyConstants.networkProxyKey, defaultValue: '');

  @override
  bool get useProxy => box.get(SettingKeyConstants.networkUseProxyKey, defaultValue: false);

  @override
  set proxy(String foo) => box.put(SettingKeyConstants.networkProxyKey, foo);

  @override
  set useProxy(bool foo) => box.put(SettingKeyConstants.networkUseProxyKey, foo);
}
