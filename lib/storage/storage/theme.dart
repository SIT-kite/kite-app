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
import 'package:hive/hive.dart';
import 'package:kite/r.dart';

import '../dao/theme.dart';

class ThemeKeys {
  static const namespace = '/theme';
  static const themeColor = '$namespace/color';
  static const isDarkMode = '$namespace/isDarkMode';
  static const lastWindowSize = '$namespace/lastWindowSize';
}

class ThemeSettingStorage implements ThemeSettingDao {
  final Box<dynamic> box;

  ThemeSettingStorage(this.box);

  @override
  Color? get color {
    // TODO: Use the Color Adapter next version
    // NOTE: The settings
    final String? value = box.get(ThemeKeys.themeColor);
    if (value != null) {
      var hex = value.replaceFirst('#', '');
      final colorValue = int.tryParse(hex, radix: 16);
      if (colorValue != null) {
        return Color(colorValue);
      }
    }
    return R.defaultThemeColor;
  }

  @override
  set color(Color? v) {
    if (v != null) {
      box.put(ThemeKeys.themeColor, v);
    }
  }

  @override
  bool? get isDarkMode => box.get(ThemeKeys.isDarkMode, defaultValue: false);

  @override
  set isDarkMode(value) => box.put(ThemeKeys.isDarkMode, value ?? false);

  @override
  Size? get lastWindowSize => box.get(ThemeKeys.lastWindowSize, defaultValue: R.defaultWindowSize);

  @override
  set lastWindowSize(value) => box.put(ThemeKeys.lastWindowSize, value ?? R.defaultWindowSize);
}
