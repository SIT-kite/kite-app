class SettingKeyConstants {
  static const homeNamespace = '/home';
  static const homeCampusKey = '$homeNamespace/campus';
  static const homeBackgroundKey = '$homeNamespace/background';
  static const homeBackgroundModeKey = '$homeNamespace/backgroundMode';
  static const homeInstallTimeKey = '$homeNamespace/installTime';

  // 首页在无网状态下加载的缓存.
  static const homeLastWeatherKey = '$homeNamespace/lastWeather';
  static const homeLastReportKey = '$homeNamespace/lastReport';
  static const homeLastBalanceKey = '$homeNamespace/lastBalance';
  static const homeLastExpenseKey = '$homeNamespace/lastExpense';
  static const homeLastHotSearchKey = '$homeNamespace/lastHotSearch';
  static const homeLastOfficeStatusKey = '$homeNamespace/lastOfficeStatus';

  static const authNamespace = '/auth';
  static const authCurrentUsername = '$authNamespace/currentUsername';

  static const themeNamespace = '/theme';
  static const themeColorKey = '$themeNamespace/color';

  static const networkNamespace = '/network';
  static const networkProxyKey = '$networkNamespace/proxy';
  static const networkUseProxyKey = '$networkNamespace/useProxy';
}
