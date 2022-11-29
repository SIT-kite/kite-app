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

import '../dao/theme.dart';

class ThemeKeys {
  static const namespace = '/theme';
  static const themeColor = '$namespace/color';
  static const isDarkMode = '$namespace/isDarkMode';
}

class ThemeSettingStorage implements ThemeSettingDao {
  final Box<dynamic> box;

  ThemeSettingStorage(this.box);

  @override
  Color get color {
    final String value = box.get(ThemeKeys.themeColor, defaultValue: 'ff2196f3');
    final int color = int.parse(value.replaceFirst('#', ''), radix: 16);
    return Color(color);
  }

  @override
  set color(Color v) {
    final String value = v.value.toRadixString(16).padLeft(6, '0');
    box.put(ThemeKeys.themeColor, value);
  }

  @override
  bool? get isDarkMode => box.get(ThemeKeys.isDarkMode);

  @override
  set isDarkMode(value) => box.put(ThemeKeys.isDarkMode, value ?? false);
}
