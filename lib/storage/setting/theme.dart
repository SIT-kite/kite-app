import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:kite/dao/setting/theme.dart';
import 'package:kite/storage/setting/constants.dart';

class ThemeSettingStorage implements ThemeSettingDao {
  final Box<dynamic> box;

  ThemeSettingStorage(this.box);

  @override
  Color get color => box.get(SettingKeyConstants.themeColorKey, defaultValue: Colors.blue.value);

  @override
  set color(Color v) => box.put(SettingKeyConstants.themeColorKey, v);
}
