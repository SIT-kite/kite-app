import 'package:flutter/cupertino.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';

import '../global/global.dart';
export 'package:kite/r.dart';

extension I18nBuildContext on BuildContext {
  AppLocalizations get l => AppLocalizations.of(this);

  Locale get locale => Localizations.localeOf(this);

  String get langCode => Localizations.localeOf(this).languageCode;

  ///e.g.: Wednesday, September 21, 2022
  String dateText(DateTime date) => DateFormat.yMMMMEEEEd(langCode).format(date);
  ///e.g.:9/21/2022
  String dateNum(DateTime date) => DateFormat.yMd(langCode).format(date);
  ///e.g.:
  String dateNumX(DateTime date) => DateFormat.yMd(langCode).format(date);
}

extension LocaleExtension on Locale {
  String dateText(DateTime date) => DateFormat.yMMMMEEEEd(languageCode).format(date);
}

AppLocalizations get i18n => AppLocalizations.of(Global.buildContext!);
