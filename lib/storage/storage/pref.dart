import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import 'package:kite/mock/index.dart';
import 'package:kite/util/dsl.dart';

import '../dao/pref.dart';

class PrefStorage implements PrefDao {
  final Box<dynamic> box;

  PrefStorage(this.box);

  @override
  Locale? get locale {
    return box.get(PrefKey.locale);
  }

  @override
  set locale(Locale? value) {
    box.put(PrefKey.locale, value);
  }
}
