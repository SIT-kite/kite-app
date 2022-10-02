class R {
  R._();

  static const appName = "上应小风筝";
  static const kiteUserAgreementName = "《上应小风筝用户协议》";
  static const kiteUserAgreementUrl = "https://kite.sunnysab.cn/license/";
  static const kiteWikiUrlFeatures = "https://kite.sunnysab.cn/wiki/kite-app/features/";
  static const forgotLoginPwdUrl =
      "https://authserver.sit.edu.cn/authserver/getBackPasswordMainPage.do?service=https%3A%2F%2Fmyportal.sit.edu.cn%3A443%2F";
  static const easyConnectDownloadUrl = "https://www.sit.edu.cn/xxfw/list.htm";
  static const kiteAboutUrl = "https://kite.sunnysab.cn/about/";
  static const kiteBbsUrl = "https://support.qq.com/products/386124";
  static const kiteFeedbackUrl = "https://support.qq.com/product/377648";
  static const kiteWikiUrl = "https://kite.sunnysab.cn/wiki/";
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
