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
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'lang.dart';

import '../global/global.dart';
export 'package:kite/r.dart';
export 'lang.dart';

extension I18nBuildContext on BuildContext {
  AppLocalizations get l => AppLocalizations.of(this);

  Locale get locale => Localizations.localeOf(this);

  String get langCode => Localizations.localeOf(this).languageCode;

  ///e.g.: Wednesday, September 21, 2022
  String dateText(DateTime date) {
    final curLocale = locale;
    return Lang.textf(curLocale.languageCode, curLocale.countryCode).format(date);
  }

  ///e.g.: 9/21/2022
  String dateNum(DateTime date) {
    final curLocale = locale;
    return Lang.numf(curLocale.languageCode, curLocale.countryCode).format(date);
  }

  ///e.g.: 9/21/2022 23:57:23
  String dateFullNum(DateTime date) {
    final curLocale = locale;
    return Lang.fullNumf(curLocale.languageCode, curLocale.countryCode).format(date);
  }

  /// e.g.: 8:32:59
  String dateTime(DateTime date) => Lang.timef.format(date);
}

extension LocaleExtension on Locale {
  String dateText(DateTime date) => DateFormat.yMMMMEEEEd(languageCode).format(date);
}

AppLocalizations get i18n => AppLocalizations.of(Global.buildContext!);

bool yOrNo(String test, {bool defaultValue = false}) {
  switch (test) {
    case "y":
      return true;
    case "n":
      return false;
    default:
      return defaultValue;
  }
}

///e.g.: Wednesday, September 21, 2022
/// [Global.buildContext] is used
String dateText(DateTime date) {
  final curLocale = Global.buildContext!.locale;
  return Lang.textf(curLocale.languageCode, curLocale.countryCode).format(date);
}

///e.g.:9/21/2022
/// [Global.buildContext] is used
String dateNum(DateTime date) {
  final curLocale = Global.buildContext!.locale;
  return Lang.numf(curLocale.languageCode, curLocale.countryCode).format(date);
}

///e.g.: 9/21/2022 23:57:23
/// [Global.buildContext] is used
String dateFullNum(DateTime date) {
  final curLocale = Global.buildContext!.locale;
  return Lang.fullNumf(curLocale.languageCode, curLocale.countryCode).format(date);
}
