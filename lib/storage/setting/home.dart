import 'package:hive/hive.dart';
import 'package:kite/dao/setting/home.dart';
import 'package:kite/entity/weather.dart';
import 'package:kite/storage/setting/constants.dart';

class HomeSettingStorage implements HomeSettingDao {
  final Box<dynamic> box;
  HomeSettingStorage(this.box);

  @override
  String get background => box.get(SettingKeyConstants.homeBackgroundKey, defaultValue: '');
  @override
  set background(String v) => box.put(SettingKeyConstants.homeBackgroundKey, v);

  @override
  int get backgroundMode => box.get(SettingKeyConstants.homeBackgroundModeKey, defaultValue: 1);

  @override
  set backgroundMode(int v) => box.put(SettingKeyConstants.homeBackgroundModeKey, v);

  @override
  int get campus => box.get(SettingKeyConstants.homeCampusKey, defaultValue: 1);

  @override
  set campus(int v) => box.put(SettingKeyConstants.homeCampusKey, v);

  @override
  Weather get lastWeather => box.get(SettingKeyConstants.homeLastWeatherKey, defaultValue: Weather.defaultWeather());

  @override
  set lastWeather(Weather weather) => box.put(SettingKeyConstants.homeLastWeatherKey, weather);

  @override
  DateTime? get installTime => box.get(SettingKeyConstants.homeInstallTimeKey);

  @override
  set installTime(DateTime? dateTime) => box.put(SettingKeyConstants.homeInstallTimeKey, dateTime);
}
