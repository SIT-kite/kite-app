import 'package:flutter/cupertino.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../global/global.dart';

extension I18nBuildContext on BuildContext {
  AppLocalizations get l => AppLocalizations.of(this);
}

AppLocalizations get i18n => AppLocalizations.of(Global.buildContext!);
