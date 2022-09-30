import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import 'package:kite/l10n/lang.dart';
import 'package:kite/storage/storage/common.dart';

import '../dao/pref.dart';

class PrefStorage extends JsonStorage implements PrefDao {
  PrefStorage(Box<dynamic> box) : super(box);

  @override
  Locale? get locale {
    return getModel<Locale>(PrefKey.locale, buildLocaleFromJson) ?? Lang.enLocale;
  }

  @override
  set locale(Locale? value) {
    setModel<Locale>(PrefKey.locale, value, (v) => v.toJson());
  }
}
