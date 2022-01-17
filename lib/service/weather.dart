import 'package:dio/dio.dart';
import 'package:json_annotation/json_annotation.dart';

part 'weather.g.dart';

String _getWeatherUrl(int campus) {
  return 'https://kite.sunnysab.cn/api/v2/weather/$campus';
}

@JsonSerializable()
class Weather {
  String weather;
  int temperature;
  String ts;
  String icon;

  Weather(this.weather, this.temperature, this.ts, this.icon);

  factory Weather.fromJson(Map<String, dynamic> json) => _$WeatherFromJson(json);
}

Future<Weather> getCurrentWeather(int campus) async {
  final url = _getWeatherUrl(campus);
  final response = await Dio().get(url);
  final weather = Weather.fromJson(response.data['data']);

  return weather;
}
