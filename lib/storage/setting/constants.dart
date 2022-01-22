import 'package:kite/util/path.dart';

class SettingKeyConstants {
  static final homeNamespace = Path().forward('home');
  static final homeCampusKey = homeNamespace.forward('campus').toString();
  static final homeBackgroundKey = homeNamespace.forward('background').toString();
  static final homeBackgroundModeKey = homeNamespace.forward('backgroundMode').toString();
  static final homeInstallTimeKey = homeNamespace.forward('installTime').toString();

  // 首页在无网状态下加载的缓存.
  static final homeLastWeatherKey = homeNamespace.forward('lastWeather').toString();
  static final homeLastReportKey = homeNamespace.forward('lastReport').toString();
  static final homeLastBalanceKey = homeNamespace.forward('lastBalance').toString();
  static final homeLastExpenseKey = homeNamespace.forward('lastExpense').toString();
  static final homeLastHotSearchKey = homeNamespace.forward('lastHotSearch').toString();
  static final homeLastOfficeStatusKey = homeNamespace.forward('lastOfficeStatus').toString();

  static final authNamespace = Path().forward('auth');
  static final authCurrentUsername = authNamespace.forward('currentUsername').toString();

  static final themeNamespace = Path().forward('theme');
  static final themeColorKey = themeNamespace.forward('color').toString();

  static final networkNamespace = Path().forward('network');
  static final networkProxyKey = networkNamespace.forward('proxy').toString();
  static final networkUseProxyKey = networkNamespace.forward('useProxy').toString();
}
