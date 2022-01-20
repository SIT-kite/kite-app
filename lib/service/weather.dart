import 'package:dio/dio.dart';
import 'package:kite/entity/weather.dart';

String _getWeatherUrl(int campus) {
  return 'https://kite.sunnysab.cn/api/v2/weather/$campus';
}

Future<Weather> getCurrentWeather(int campus) async {
  final url = _getWeatherUrl(campus);
  final response = await Dio().get(url);
  final weather = Weather.fromJson(response.data['data']);

  return weather;
}
