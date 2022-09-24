import 'dart:ui';

import 'package:hive/hive.dart';

import '../dao/pref.dart';

class PrefStorage implements PrefDao {
  final Box<dynamic> box;

  PrefStorage(this.box);

  @override
  Locale get locale {
    final String langCode = box.get(PrefKeys.locale, defaultValue: const Locale.fromSubtags(languageCode: "zh"));
    return Locale(langCode);
  }

  @override
  set locale(Locale value) => box.put(PrefKeys.locale, value.languageCode);
}
