/*
 *    上应小风筝(SIT-kite)  便利校园，一步到位
 *    Copyright (C) 2022 上海应用技术大学 上应小风筝团队
 *
 *    This program is free software: you can redistribute it and/or modify
 *    it under the terms of the GNU General Public License as published by
 *    the Free Software Foundation, either version 3 of the License, or
 *    (at your option) any later version.
 *
 *    This program is distributed in the hope that it will be useful,
 *    but WITHOUT ANY WARRANTY; without even the implied warranty of
 *    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *    GNU General Public License for more details.
 *
 *    You should have received a copy of the GNU General Public License
 *    along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/
import 'package:flutter/material.dart';
import 'package:kite/design/utils.dart';

Color getThemeColor(BuildContext ctx) {
  var theme = Theme.of(ctx);
  if (theme.isLight) {
    return theme.primaryColor;
  } else {
    return theme.colorScheme.onPrimary;
  }
}

extension DesignExtension on BuildContext {
  Color get themeColor => getThemeColor(this);
}

class ColorPair {
  final Color light;
  final Color dark;

  const ColorPair(this.light, this.dark);

  factory ColorPair.from(int light, int dark) {
    return ColorPair(Color(light), Color(dark));
  }
}

/// https://m3.material.io/theme-builder#/custom
class CourseColor {
  /// Raw color is in HTC
  static const List<ColorPair> all = [
    ColorPair(Color(0xFF85e779), Color(0xFF16520f)), // green #678a5c
    ColorPair(Color(0xFFc3e8ff), Color(0xFF004c68)), // sky #5487a3
    ColorPair(Color(0xFFffd9e2), Color(0xFF7b294a)), // pink #ae6f83
    ColorPair(Color(0xFFad9bd7), Color(0xFF50378a)), // violet #8879ab
    ColorPair(Color(0xFFff9d6b), Color(0xFF7f2b00)), // orange #a23900
    ColorPair(Color(0xFFffa2d2), Color(0xFF8e004a)), // rose #b50060
    ColorPair(Color(0xFFfbe365), Color(0xFF524700)), // lemon #b09e40
    ColorPair(Color(0xFF75f8e2), Color(0xFF005047)), // cyan #008f7f
    ColorPair(Color(0xFFb4ebff), Color(0xFF004e5f)), // ice #b3c7cf
    ColorPair(Color(0xFFb4ebff), Color(0xFF004e5f)), // cyan #d4bdce
    ColorPair(Color(0xFFffd7f5), Color(0xFF7c157a)), // mauve #ff8df3
    ColorPair(Color(0xFFcdf141), Color(0xFF3e4c00)), // toxic #a2c300
  ];

  static get({required ThemeData from, required int by}) {
    final pair = all[by.abs() % all.length];
    if (from.brightness == Brightness.light) {
      return pair.light;
    } else {
      return pair.dark;
    }
  }
}
