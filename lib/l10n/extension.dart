import 'package:flutter/cupertino.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

extension I18nBuildContext on BuildContext{
  AppLocalizations get l => AppLocalizations.of(this)!;
}
