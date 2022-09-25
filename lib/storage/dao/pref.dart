import 'dart:ui';

class PrefKey{
  PrefKey._();
  static const locale = "locale";
}

abstract class PrefDao {
  Locale get locale;

  set locale(Locale value);
}
