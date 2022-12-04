/*
 * 上应小风筝  便利校园，一步到位
 * Copyright (C) 2022 上海应用技术大学 上应小风筝团队
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */
import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:kite/global/hive_type_id_pool.dart';
import 'package:kite/l10n/extension.dart';

part 'weather.g.dart';

@JsonSerializable()
@HiveType(typeId: HiveTypeId.weatherItem)
class Weather {
  @HiveField(0)
  String weather;
  @HiveField(1)
  int temperature;
  @HiveField(2)
  String ts;
  @HiveField(3)
  String icon;

  Weather(this.weather, this.temperature, this.ts, this.icon);
  static const defaultWeatherCode = 100;
  static Weather get defaultWeather {
    return Weather(i18n.weather_sunny, 20, DateTime.now().toString(), defaultWeatherCode.toString());
  }

  factory Weather.fromJson(Map<String, dynamic> json) => _$WeatherFromJson(json);

  @override
  String toString() {
    return 'Weather{weather: $weather, temperature: $temperature, ts: $ts, icon: $icon}';
  }
}
