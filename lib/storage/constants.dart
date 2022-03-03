/*
 * 上应小风筝  便利校园，一步到位
 * Copyright (C) 2022 上海应用技术大学 上应小风筝团队
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */
class HomeKeyKeys {
  static const namespace = '/home';
  static const campus = '$namespace/campus';
  static const background = '$namespace/background';
  static const backgroundMode = '$namespace/backgroundMode';
  static const installTime = '$namespace/installTime';
  static const homeItems = '$namespace/homeItems';

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
  static const isDarkMode = '$namespace/isDarkMode';
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
