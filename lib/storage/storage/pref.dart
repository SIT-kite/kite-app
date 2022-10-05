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
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:kite/l10n/lang.dart';
import 'package:kite/storage/storage/common.dart';

import '../dao/pref.dart';

class PrefStorage extends JsonStorage implements PrefDao {
  PrefStorage(Box<dynamic> box) : super(box);

  @override
  Locale? get locale {
    return getModel<Locale>(PrefKey.locale, buildLocaleFromJson) ??
        Lang.enLocale;
  }

  @override
  set locale(Locale? value) {
    setModel<Locale>(PrefKey.locale, value, (v) => v.toJson());
  }
}
