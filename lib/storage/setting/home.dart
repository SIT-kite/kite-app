import 'package:hive/hive.dart';
import 'package:kite/dao/setting/home.dart';
import 'package:kite/storage/setting/constants.dart';

class HomeSettingStorage implements HomeSettingDao {
  final Box<dynamic> box;
  HomeSettingStorage(this.box);

  @override
  String get background => box.get(SettingKeyConstants.homeBackgroundKey, defaultValue: '');
  @override
  set background(String v) => box.put(SettingKeyConstants.homeBackgroundKey, v);

  @override
  String get backgroundMode => box.get(SettingKeyConstants.homeBackgroundModeKey, defaultValue: 'weather');
  @override
  set backgroundMode(String v) => box.put(SettingKeyConstants.homeBackgroundModeKey, v);

  @override
  int get campus => box.get(SettingKeyConstants.homeCampusKey, defaultValue: 1);
  @override
  set campus(int v) => box.put(SettingKeyConstants.homeCampusKey, v);
}
