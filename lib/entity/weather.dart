import 'package:json_annotation/json_annotation.dart';

part 'weather.g.dart';

@JsonSerializable()
class Weather {
  String weather;
  int temperature;
  String ts;
  String icon;

  Weather(this.weather, this.temperature, this.ts, this.icon);

  factory Weather.fromJson(Map<String, dynamic> json) => _$WeatherFromJson(json);
}
