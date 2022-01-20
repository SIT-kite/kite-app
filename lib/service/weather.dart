import 'package:dio/dio.dart';
import 'package:kite/dao/weatcher.dart';
import 'package:kite/entity/weather.dart';

class WeatherService implements WeatherDao {
  static String _getWeatherUrl(int campus) => 'https://kite.sunnysab.cn/api/v2/weather/$campus';

  @override
  Future<Weather> getCurrentWeather(int campus) async {
    final url = _getWeatherUrl(campus);
    final response = await Dio().get(url);
    final weather = Weather.fromJson(response.data['data']);

    return weather;
  }
}
