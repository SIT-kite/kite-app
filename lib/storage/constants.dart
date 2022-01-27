class HomeKeyKeys {
  static const namespace = '/home';
  static const campus = '$namespace/campus';
  static const background = '$namespace/background';
  static const backgroundMode = '$namespace/backgroundMode';
  static const installTime = '$namespace/installTime';

  // 首页在无网状态下加载的缓存.
  static const lastWeather = '$namespace/lastWeather';
  static const lastReport = '$namespace/lastReport';
  static const lastBalance = '$namespace/lastBalance';
  static const lastExpense = '$namespace/lastExpense';
  static const lastHotSearch = '$namespace/lastHotSearch';
  static const lastOfficeStatus = '$namespace/lastOfficeStatus';

  static const readNotice = '$namespace/readNotice';
}

class AuthKeys {
  static const namespace = '/auth';
  static const currentUsername = '$namespace/currentUsername';
}

class ThemeKeys {
  static const namespace = '/theme';
  static const themeColor = '$namespace/color';
}

class NetworkKeys {
  static const namespace = '/network';
  static const networkProxy = '$namespace/proxy';
  static const networkUseProxy = '$namespace/useProxy';
}

class JwtKeys {
  static const namespace = '/kite';
  static const jwt = '$namespace/jwt';
}
