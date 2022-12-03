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
import 'package:rettulf/rettulf.dart';
import 'package:tuple/tuple.dart';

Color getThemeColor(BuildContext ctx) {
  var theme = Theme.of(ctx);
  if (theme.isLight) {
    return theme.primaryColor;
  } else {
    return theme.colorScheme.onPrimary;
  }
}

Color getFgColor(BuildContext ctx) {
  var theme = Theme.of(ctx);
  if (theme.isLight) {
    return theme.primaryColor;
  } else {
    return theme.colorScheme.onSurface;
  }
}

Color getBgColor(BuildContext ctx) {
  var theme = Theme.of(ctx);
  if (theme.isLight) {
    return theme.colorScheme.onPrimary;
  } else {
    return theme.colorScheme.onSecondary;
  }
}

Color getChessBoardColor(BuildContext ctx, int index) {
  if (ctx.isLightMode) {
    return index.isOdd ? Colors.white : Colors.black12;
  } else {
    return index.isOdd ? Colors.black38 : Colors.white12;
  }
}

extension DesignExtension on BuildContext {
  Color get themeColor => getThemeColor(this);

  Color get fgColor => getFgColor(this);

  Color get bgColor => getBgColor(this);

  Color chessBoardColor({required int at}) => getChessBoardColor(this, at);

  Color get textColor => isDarkMode ? Colors.white70 : theme.primaryColor;

  Tuple2<Color, Color> makeTabHeaderTextNBgColors(bool isSelected) {
    final Color textColor;
    final Color bgColor;
    if (isDarkMode) {
      if (isSelected) {
        bgColor = theme.secondaryHeaderColor;
      } else {
        bgColor = Colors.transparent;
      }
      textColor = Colors.white;
    } else {
      if (isSelected) {
        bgColor = theme.primaryColor;
        textColor = Colors.white;
      } else {
        bgColor = Colors.transparent;
        textColor = Colors.black;
      }
    }
    return Tuple2(textColor, bgColor);
  }
}

class ColorPair {
  final Color light;
  final Color dark;

  const ColorPair(this.light, this.dark);

  factory ColorPair.from(int light, int dark) {
    return ColorPair(Color(light), Color(dark));
  }
}

extension ColorPairHelper on ColorPair {
  Color by(BuildContext ctx) => ctx.isDarkMode ? dark : light;

  Color byTheme(ThemeData theme) => theme.isDark ? dark : light;
}

/// https://m3.material.io/theme-builder#/custom
class CourseColor {
  /// Raw color is in HTC
  static const List<ColorPair> all = [
    ColorPair(Color(0xFF85e779), Color(0xFF21520f)), // green #678a5c
    ColorPair(Color(0xFFc3e8ff), Color(0xFF004c68)), // sky #5487a3
    ColorPair(Color(0xFFffa6bb), Color(0xFF8e2f56)), // pink #ae6f83
    ColorPair(Color(0xFFad9bd7), Color(0xFF50378a)), // violet #8879ab
    ColorPair(Color(0xFFff9d6b), Color(0xFF7f2b00)), // orange #a23900
    ColorPair(Color(0xFFffa2d2), Color(0xFF8e0032)), // rose #b50060
    ColorPair(Color(0xFFffd200), Color(0xFF523900)), // lemon #b09e40
    ColorPair(Color(0xFF75f8e2), Color(0xFF005047)), // cyan #008f7f
    ColorPair(Color(0xFFb4ebff), Color(0xFF004e5f)), // ice #b3c7cf
    ColorPair(Color(0xFFb4ebff), Color(0xFF004e5f)), // cyan #d4bdce
    ColorPair(Color(0xFFffd7f5), Color(0xFF7c157a)), // mauve #ff8df3
    ColorPair(Color(0xFFeaf141), Color(0xFF4b4c00)), // toxic #a2c300
  ];

  static get({required ThemeData from, required int by}) => all[by.abs() % all.length].byTheme(from);
}

const electricityColor = ColorPair(Color(0xFFffd200), Color(0xFFfffc00));
