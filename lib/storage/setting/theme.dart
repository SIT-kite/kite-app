import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:kite/dao/setting/theme.dart';
import 'package:kite/storage/setting/constants.dart';

class ThemeSettingStorage implements ThemeSettingDao {
  final Box<dynamic> box;

  ThemeSettingStorage(this.box);

  @override
  Color get color {
    final String value = box.get(SettingKeyConstants.themeColorKey, defaultValue: 'ff2196f3');
    final int color = int.parse(value.replaceFirst('#', ''), radix: 16);
    return Color(color);
  }

  @override
  set color(Color v) {
    final String value = v.value.toRadixString(16).padLeft(6, '0');
    box.put(SettingKeyConstants.themeColorKey, value);
  }
}