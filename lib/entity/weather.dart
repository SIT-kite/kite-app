import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:kite/global/hive_type_id_pool.dart';

part 'weather.g.dart';

@JsonSerializable()
@HiveType(typeId: HiveTypeIdPool.weatherItem)
class Weather extends HiveObject {
  @HiveField(0)
  String weather;
  @HiveField(1)
  int temperature;
  @HiveField(2)
  String ts;
  @HiveField(3)
  String icon;

  Weather(this.weather, this.temperature, this.ts, this.icon);

  static Weather defaultWeather() {
    return Weather('晴', 20, DateTime.now().toString(), '100');
  }

  factory Weather.fromJson(Map<String, dynamic> json) => _$WeatherFromJson(json);
}
