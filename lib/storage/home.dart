import 'package:hive/hive.dart';
import 'package:kite/dao/setting/home.dart';
import 'package:kite/entity/electricity.dart';
import 'package:kite/entity/report.dart';
import 'package:kite/entity/weather.dart';
import 'package:kite/storage/constants.dart';

class HomeSettingStorage implements HomeSettingDao {
  final Box<dynamic> box;

  HomeSettingStorage(this.box);

  @override
  String get background => box.get(HomeKeyKeys.background, defaultValue: '');

  @override
  set background(String v) => box.put(HomeKeyKeys.background, v);

  @override
  int get backgroundMode => box.get(HomeKeyKeys.backgroundMode, defaultValue: 1);

  @override
  set backgroundMode(int v) => box.put(HomeKeyKeys.backgroundMode, v);

  @override
  int get campus => box.get(HomeKeyKeys.campus, defaultValue: 1);

  @override
  set campus(int v) => box.put(HomeKeyKeys.campus, v);

  @override
  DateTime? get installTime => box.get(HomeKeyKeys.installTime);

  @override
  set installTime(DateTime? dateTime) => box.put(HomeKeyKeys.installTime, dateTime);

  @override
  Weather get lastWeather => box.get(HomeKeyKeys.lastWeather, defaultValue: Weather.defaultWeather());

  @override
  set lastWeather(Weather weather) => box.put(HomeKeyKeys.lastWeather, weather);

  @override
  ReportHistory? get lastReport => box.get(HomeKeyKeys.lastReport);

  @override
  set lastReport(ReportHistory? reportHistory) => box.put(HomeKeyKeys.lastReport, reportHistory);

  @override
  Balance? get lastBalance => box.get(HomeKeyKeys.lastBalance);

  @override
  set lastBalance(Balance? lastBalance) => box.put(HomeKeyKeys.lastBalance, lastBalance);

  @override
  String? get lastHotSearch => box.get(HomeKeyKeys.lastHotSearch);

  @override
  set lastHotSearch(String? expense) => box.put(HomeKeyKeys.lastHotSearch, expense);

  @override
  String? get lastOfficeStatus => box.get(HomeKeyKeys.lastOfficeStatus);

  @override
  set lastOfficeStatus(String? status) => box.put(HomeKeyKeys.lastOfficeStatus, status);
}
