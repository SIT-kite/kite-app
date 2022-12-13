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

typedef _C = Color;

Color getThemeColor(BuildContext ctx) {
  final theme = ctx.theme;
  if (theme.isLight) {
    return theme.primaryColor;
  } else {
    return theme.colorScheme.onPrimary;
  }
}

Color getDarkSafeThemeColor(BuildContext ctx) {
  final theme = ctx.theme;
  if (theme.isLight) {
    return theme.primaryColor;
  } else {
    return Color.lerp(theme.colorScheme.onPrimary, Colors.white, 0.6)!;
  }
}

Color getFgColor(BuildContext ctx) {
  final theme = ctx.theme;
  if (theme.isLight) {
    return theme.primaryColor;
  } else {
    return theme.colorScheme.onSurface;
  }
}

Color getBgColor(BuildContext ctx) {
  var theme = Theme.of(ctx);
  if (theme.isLight) {
    return Color.lerp(theme.primaryColor, Colors.white, 0.9)!;
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

  Color get darkSafeThemeColor => getDarkSafeThemeColor(this);

  Color get fgColor => getFgColor(this);

  Color get bgColor => getBgColor(this);

  Color chessBoardColor({required int at}) => getChessBoardColor(this, at);

  Color get textColor => isDarkMode ? Colors.white70 : theme.primaryColor;

  Tuple2<Color, Color> makeTabHeaderTextBgColors(bool isSelected) {
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

typedef _Cp = ColorPair;

/// https://m3.material.io/theme-builder#/custom
class CourseColor {
  /// Raw color is in HTC
  static const List<ColorPair> all = [
    _Cp(_C(0xFF85e779), _C(0xFF21520f)), // green #678a5c
    _Cp(_C(0xFFc3e8ff), _C(0xFF004c68)), // sky #5487a3
    _Cp(_C(0xFFffa6bb), _C(0xFF8e2f56)), // pink #ae6f83
    _Cp(_C(0xFFad9bd7), _C(0xFF50378a)), // violet #8879ab
    _Cp(_C(0xFFff9d6b), _C(0xFF7f2b00)), // orange #a23900
    _Cp(_C(0xFFffa2d2), _C(0xFF8e0032)), // rose #b50060
    _Cp(_C(0xFFffd200), _C(0xFF523900)), // lemon #b09e40
    _Cp(_C(0xFF75f8e2), _C(0xFF005047)), // cyan #008f7f
    _Cp(_C(0xFFb4ebff), _C(0xFF004e5f)), // ice #b3c7cf
    _Cp(_C(0xFFb4ebff), _C(0xFF004e5f)), // cyan #d4bdce
    _Cp(_C(0xFFffd7f5), _C(0xFF7c157a)), // mauve #ff8df3
    _Cp(_C(0xFFeaf141), _C(0xFF4b4c00)), // toxic #a2c300
  ];

  static get({required ThemeData from, required int by}) => all[by.abs() % all.length].byTheme(from);
}

const electricityColor = ColorPair(Color(0xFFffd200), Color(0xFFfffc00));

const List<Color> applicationColors = <Color>[
  Colors.orangeAccent,
  Colors.redAccent,
  Colors.blueAccent,
  Colors.grey,
  Colors.green,
  Colors.yellowAccent,
  Colors.cyan,
  Colors.purple,
  Colors.teal,
];

class IconPair {
  final IconData icon;
  final Color color;

  const IconPair(this.icon, this.color);
}
