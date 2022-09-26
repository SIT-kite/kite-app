import 'dart:ui';

import 'package:hive/hive.dart';
import 'package:kite/global/hive_type_id_pool.dart';
import 'package:kite/l10n/lang.dart';
import 'package:kite/util/strings.dart';

class LocaleAdaptor extends TypeAdapter<Locale> {
  @override
  int get typeId => HiveTypeIdPool.locale;

  @override
  Locale read(BinaryReader reader) {
    final languageCode = reader.readString();
    final scriptCode = reader.readString();
    final countryCode = reader.readString();
    return Locale.fromSubtags(
        languageCode: languageCode.notEmptyOr(Lang.en),
        scriptCode: scriptCode.nullIf(equals: ""),
        countryCode: countryCode.nullIf(equals: ""));
  }

  @override
  void write(BinaryWriter writer, Locale obj) {
    writer
      ..writeString(obj.languageCode)
      ..writeString(obj.scriptCode ?? "")
      ..writeString(obj.countryCode ?? "");
  }
}
