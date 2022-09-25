class R {
  R._();

  static const appName = "上应小风筝";
  static const kiteUserAgreementName = "《上应小风筝用户协议》";
  static const kiteUserAgreementUrl = "https://kite.sunnysab.cn/license/";
  static const kiteWikiUrl = "https://kite.sunnysab.cn/wiki/kite-app/features/";
  static const forgotLoginPwdUrl =
      "https://authserver.sit.edu.cn/authserver/getBackPasswordMainPage.do?service=https%3A%2F%2Fmyportal.sit.edu.cn%3A443%2F";

  static const localeEn = "en";
  static const localeZh = "zh";
}

class CampusCode {
  CampusCode._();

  static const fengxian = 1;
  static const xuhui = 2;
}

class WeatherCode {
  WeatherCode._();

  /// campus 1
  @CampusCode.fengxian
  static const fengxian = "101021000";

  /// campus 2
  @CampusCode.xuhui
  static const xuhui = "101021200";

  static from({required int campus}) => campus == 1 ? fengxian : xuhui;
}

class Lang {
  Lang._();

  static const zh = "zh";
  static const zhTW = "zhTW";
  static const en = "en";
  @zh
  static const zhCode = 1;
  @zhTWCode
  static const zhTWCode = 2;
  @enCode
  static const enCode = 3;

  static int? toCode(String lang) {
    switch (lang) {
      case zh:
        return zhCode;
      case zhTW:
        return zhTWCode;
      case en:
        return enCode;
    }
    return null;
  }
}
