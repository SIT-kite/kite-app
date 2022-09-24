import 'dart:ui';

class PrefKeys{
  PrefKeys._();
  static const locale = "locale";
}

abstract class PrefDao {
  Locale get locale;

  set locale(Locale value);
}
