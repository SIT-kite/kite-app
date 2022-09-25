import 'dart:ui';

import 'package:intl/intl.dart';

///
/// `Lang` provides a list of all languages Kite supports as well as a da
class Lang {
  Lang._();

  static const zh = "zh";
  static const zhTw = "zh_TW";
  static const en = "en";
  static const zhCode = 1;
  static const zhTwCode = 2;
  static const enCode = 3;

  static final zhTextf = DateFormat("yyyy年M月d日' EEEE", "zh_CN");
  static final zhTwTextf = DateFormat("yyyy年M月d日' EEEE", "zh_TW");
  static final enTextf = DateFormat("EEEE, MMMM d, yyyy", "en_US");

  static final zhNumf = DateFormat("yyyy-M-d", "zh_CN");
  static final zhTwNumf = DateFormat("yyyy-M-d", "zh_TW");
  static final enNumf = DateFormat("M/d/yy", "en_US");

  static final zhFullNumf = DateFormat("yy/MM/dd H:mm::ss", "zh_CN");
  static final zhTwFullNumf = DateFormat("yyMM/dd H:mm::ss", "zh_TW");
  static final enFullNumf = DateFormat("MM/dd/yy H:mm::ss", "en_US");

  static final timef = DateFormat("H:mm::ss");

  static int? toCode(String lang) {
    switch (lang) {
      case zh:
        return zhCode;
      case zhTw:
        return zhTwCode;
      case en:
        return enCode;
    }
    return null;
  }

  static DateFormat textf(String langCode) {
    switch (langCode) {
      case zh:
        return zhTextf;
      case zhTw:
        return zhTwTextf;
      case en:
        return enTextf;
    }
    return zhTextf;
  }

  static DateFormat numf(String langCode) {
    switch (langCode) {
      case zh:
        return zhNumf;
      case zhTw:
        return zhTwNumf;
      case en:
        return enNumf;
    }
    return zhNumf;
  }

  static DateFormat fullNumf(String langCode) {
    switch (langCode) {
      case zh:
        return zhFullNumf;
      case zhTw:
        return zhTwFullNumf;
      case en:
        return enFullNumf;
    }
    return zhFullNumf;
  }
}
