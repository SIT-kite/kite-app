import 'package:flutter/cupertino.dart';

extension StringfulWidget on String {
  Text get txt => Text(this);
}

extension LocaleConverter on String {
  Locale toLocaleByLangCode() => Locale(this);
}
