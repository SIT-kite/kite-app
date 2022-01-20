import 'package:kite/entity/weather.dart';

abstract class HomeSettingDao {
  int get campus;

  set campus(int value);

  String get background;

  set background(String path);

  int get backgroundMode;

  set backgroundMode(int mode);

  Weather get lastWeather;

  set lastWeather(Weather weather);
}
