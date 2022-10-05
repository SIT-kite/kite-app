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

import 'package:flutter/material.dart';
import '../using.dart';

const String _ventuskyUrl = 'https://www.ventusky.com/?p=31.046;121.773;10&l=rain-1h';

String _getWeatherUrl(int campus) {
  String location = WeatherCode.from(campus: campus);
  return 'https://widget-page.qweather.net/h5/index.html?md=0123456&bg=1&lc=$location&key=f96261862c08497c90c0dea53467f511';
}

class WeatherPage extends StatelessWidget {
  final int campus;
  final String? title;

  // TODO: Don't change any state in a stateless widget
  bool simple = true;
  late WebViewController controller;

  WeatherPage(this.campus, {this.title, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final url = _getWeatherUrl(campus);

    return SimpleWebViewPage(
      initialUrl: url,
      fixedTitle: title ?? i18n.weather,
      onWebViewCreated: (controller) {
        this.controller = controller;
      },
      otherActions: [
        IconButton(
          onPressed: () {
            simple = !simple;
            if (simple) {
              controller.loadUrl(url);
            } else {
              controller.loadUrl(_ventuskyUrl);
            }
          },
          icon: const Icon(Icons.swap_horiz),
        ),
      ],
    );
  }
}
