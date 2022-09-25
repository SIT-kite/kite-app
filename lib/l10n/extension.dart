import 'package:flutter/cupertino.dart';
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
  String dateText(DateTime date) => Lang.textf(langCode).format(date);

  ///e.g.:9/21/2022
  String dateNum(DateTime date) => Lang.numf(langCode).format(date);

  ///e.g.: 9/21/2022 23:57:23
  String dateFullNum(DateTime date) => Lang.fullNumf(langCode).format(date);

  /// e.g.: 8:32:59
  String dateTime(DateTime date) => Lang.timef.format(date);
}

extension LocaleExtension on Locale {
  String dateText(DateTime date) => DateFormat.yMMMMEEEEd(languageCode).format(date);
}

AppLocalizations get i18n => AppLocalizations.of(Global.buildContext!);
