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
import 'package:dio/dio.dart';
import 'package:kite/backend.dart';
import 'package:kite/l10n/extension.dart';
import 'package:kite/storage/init.dart';

import '../dao/weather.dart';
import '../entity/weather.dart';

class WeatherService implements WeatherDao {
  static String _getWeatherUrl(int campus, int lang) => '${Backend.kite}/api/v2/weather/$campus?lang=$lang';

  @override
  Future<Weather> getCurrentWeather(int campus) async {
    var lang = Kv.pref.locale?.languageCode ?? Lang.zh;
    final url = _getWeatherUrl(campus, Lang.toCode(lang) ?? Lang.zhCode);
    final response = await Dio().get(url);
    final weather = Weather.fromJson(response.data['data']);

    return weather;
  }
}
