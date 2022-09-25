import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import 'package:kite/util/dsl.dart';

import '../dao/pref.dart';

class PrefStorage implements PrefDao {
  final Box<dynamic> box;

  PrefStorage(this.box);

  @override
  Locale? get locale {
    final String? langCode = box.get(PrefKey.locale);
    return langCode?.toLocaleByLangCode();
  }

  @override
  set locale(Locale? value) {
    if (value != null) {
      box.put(PrefKey.locale, value.languageCode);
    }
  }
}
