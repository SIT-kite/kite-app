import 'package:hive/hive.dart';
import 'package:kite/dao/setting/home.dart';
import 'package:kite/entity/electricity.dart';
import 'package:kite/entity/expense.dart';
import 'package:kite/entity/report.dart';
import 'package:kite/entity/weather.dart';
import 'package:kite/storage/constants.dart';

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
  DateTime? get installTime => box.get(SettingKeyConstants.homeInstallTimeKey);

  @override
  set installTime(DateTime? dateTime) => box.put(SettingKeyConstants.homeInstallTimeKey, dateTime);

  @override
  Weather get lastWeather => box.get(SettingKeyConstants.homeLastWeatherKey, defaultValue: Weather.defaultWeather());

  @override
  set lastWeather(Weather weather) => box.put(SettingKeyConstants.homeLastWeatherKey, weather);

  @override
  ReportHistory? get lastReport => box.get(SettingKeyConstants.homeLastReportKey);

  @override
  set lastReport(ReportHistory? reportHistory) => box.put(SettingKeyConstants.homeLastReportKey, reportHistory);

  @override
  Balance? get lastBalance => box.get(SettingKeyConstants.homeLastBalanceKey);

  @override
  set lastBalance(Balance? lastBalance) => box.put(SettingKeyConstants.homeLastBalanceKey, lastBalance);

  @override
  ExpenseRecord? get lastExpense => box.get(SettingKeyConstants.homeLastExpenseKey);

  @override
  set lastExpense(ExpenseRecord? expense) => box.put(SettingKeyConstants.homeLastExpenseKey, expense);

  @override
  String? get lastHotSearch => box.get(SettingKeyConstants.homeLastHotSearchKey);

  @override
  set lastHotSearch(String? expense) => box.put(SettingKeyConstants.homeLastHotSearchKey, expense);

  @override
  String? get lastOfficeStatus => box.get(SettingKeyConstants.homeLastOfficeStatusKey);

  @override
  set lastOfficeStatus(String? status) => box.put(SettingKeyConstants.homeLastOfficeStatusKey, status);
}
