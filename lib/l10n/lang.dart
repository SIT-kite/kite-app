/*
 *    上应小风筝(SIT-kite)  便利校园，一步到位
 *    Copyright (C) 2022 上海应用技术大学 上应小风筝团队
 *
 *    This program is free software: you can redistribute it and/or modify
 *    it under the terms of the GNU General Public License as published by
 *    the Free Software Foundation, either version 3 of the License, or
 *    (at your option) any later version.
 *
 *    This program is distributed in the hope that it will be useful,
 *    but WITHOUT ANY WARRANTY; without even the implied warranty of
 *    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *    GNU General Public License for more details.
 *
 *    You should have received a copy of the GNU General Public License
 *    along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/
import 'dart:ui';

import 'package:intl/intl.dart';

Locale buildLocaleFromJson(Map<String, dynamic> json) {
  return Locale.fromSubtags(
    languageCode: json['languageCode'],
    scriptCode: json['scriptCode'],
    countryCode: json['countryCode'],
  );
}

extension LocaleToJson on Locale {
  Map<String, dynamic> toJson() {
    return {
      'languageCode': languageCode,
      'scriptCode': scriptCode,
      'countryCode': countryCode,
    };
  }
}

///
/// `Lang` provides a list of all languages Kite supports as well as a da
class Lang {
  Lang._();

  static const zh = "zh";
  static const zhTw = "zh_TW";
  static const tw = "TW";
  static const en = "en";

  static const zhLocale = Locale.fromSubtags(languageCode: "zh");
  static const zhTwLocale = Locale.fromSubtags(languageCode: "zh", scriptCode: "Hant", countryCode: "TW");
  static const enLocale = Locale.fromSubtags(languageCode: "en");

  static const zhCode = 1;
  static const zhTwCode = 2;
  static const enCode = 3;

  static final zhTextf = DateFormat("yyyy年M月d日 EEEE", "zh_CN");
  static final zhTwTextf = DateFormat("yyyy年M月d日 EEEE", "zh_TW");
  static final enTextf = DateFormat("EEEE, MMMM d, yyyy", "en_US");

  static final zhNumf = DateFormat("yyyy-M-d", "zh_CN");
  static final zhTwNumf = DateFormat("yyyy-M-d", "zh_TW");
  static final enNumf = DateFormat("M-d-yyyy", "en_US");

  static final zhFullNumf = DateFormat("yy/MM/dd H:mm::ss", "zh_CN");
  static final zhTwFullNumf = DateFormat("yy/MM/dd H:mm::ss", "zh_TW");
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

  static DateFormat textf(String lang, String? country) {
    if (lang == zh) {
      if (country == null) {
        return zhTextf;
      } else if (country == tw) {
        return zhTextf;
      }
    } else if (lang == en) {
      return enTextf;
    }
    return zhTextf;
  }

  static DateFormat numf(String lang, String? country) {
    if (lang == zh) {
      if (country == null) {
        return zhNumf;
      } else if (country == tw) {
        return zhNumf;
      }
    } else if (lang == en) {
      return enNumf;
    }
    return zhNumf;
  }

  static DateFormat fullNumf(String lang, String? country) {
    if (lang == zh) {
      if (country == null) {
        return zhFullNumf;
      } else if (country == tw) {
        return zhTwFullNumf;
      }
    } else if (lang == en) {
      return enFullNumf;
    }
    return zhFullNumf;
  }

  static const supports = [
    Locale.fromSubtags(languageCode: 'en'), // generic English 'en'
    Locale.fromSubtags(languageCode: 'zh', countryCode: 'TW'), // generic traditional Chinese 'zh_Hant'
    Locale.fromSubtags(languageCode: 'zh'), // generic Chinese 'zh'
  ];
}
