import 'package:kite/entity/electricity.dart';
import 'package:kite/entity/report.dart';
import 'package:kite/entity/weather.dart';

abstract class HomeSettingDao {
  int get campus;

  set campus(int value);

  String get background;

  set background(String path);

  int get backgroundMode;

  set backgroundMode(int mode);

  DateTime? get installTime;

  set installTime(DateTime? dateTime);

  Weather get lastWeather;

  set lastWeather(Weather weather);

  // 首页在无网状态下加载的缓存
  ReportHistory? get lastReport;

  set lastReport(ReportHistory? reportHistory);

  Balance? get lastBalance;

  set lastBalance(Balance? lastBalance);

  String? get lastHotSearch;

  set lastHotSearch(String? hotSearch);

  String? get lastOfficeStatus;

  set lastOfficeStatus(String? status);
}
