/*
 * 上应小风筝(SIT-kite)  便利校园，一步到位
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
import 'package:catcher/core/catcher.dart';
import 'package:dynamic_color_theme/dynamic_color_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kite/global/storage_pool.dart';
import 'package:kite/page/index.dart';
import 'package:kite/util/page_logger.dart';

final _routes = {
  '/home': (context) => const HomePage(),
  '/report': (context) => const DailyReportPage(),
  '/login': (context) => const LoginPage(),
  '/welcome': (context) => const WelcomePage(),
  '/about': (context) => const AboutPage(),
  '/expense': (context) => const ExpensePage(),
  '/connectivity': (context) => const ConnectivityPage(),
  '/campusCard': (context) => CampusCardPage(),
  '/electricity': (context) => const ElectricityPage(),
  '/score': (context) => const ScorePage(),
  '/office': (context) => const OfficePage(),
  '/game': (context) => const Game2048Page(),
  '/wiki': (context) => const WikiPage(),
  '/library': (context) => const LibraryPage(),
  '/market': (context) => const MarketPage(),
  '/timetable': (context) => const TimetablePage(),
  '/setting': (context) => SettingPage(),
  '/feedback': (context) => const FeedbackPage(),
  '/notice': (context) => const NoticePage(),
  '/contact': (context) => const ContactPage(),
  '/bulletin': (context) => const BulletinPage(),
  '/mail': (context) => MailPage(),
  '/night': (context) => NightPage(),
  '/event': (context) => EventPage(),
  '/lost-found': (context) => LostFoundPage(),
  '/classroom': (context) => ClassroomPage(),
};

class KiteApp extends StatelessWidget {
  const KiteApp({Key? key}) : super(key: key);

  Route<dynamic> _onGenerateRoute(RouteSettings settings) {
    pageLogger.page(settings.name ?? 'Unknown');
    return MaterialPageRoute(
      builder: (context) => _routes[settings.name]!(context),
      settings: settings,
    );
  }

  TextTheme _buildTextTheme(BuildContext context) {
    return const TextTheme(
      headline1: TextStyle(fontSize: 28.0, fontWeight: FontWeight.bold),
      headline2: TextStyle(fontSize: 26.0),
      headline3: TextStyle(fontSize: 24.0),
      headline4: TextStyle(fontSize: 22.0),
      headline6: TextStyle(fontSize: 20.0),
      bodyText1: TextStyle(fontSize: 18.0, fontWeight: FontWeight.normal),
      bodyText2: TextStyle(fontSize: 16.0, color: Colors.black26, fontWeight: FontWeight.w600),
    );
  }

  ThemeData _buildTheme(BuildContext context, Color primaryColor, bool isDark) {
    return ThemeData(
      colorSchemeSeed: primaryColor,
      textTheme: _buildTextTheme(context),
      brightness: isDark ? Brightness.dark : Brightness.light,
      useMaterial3: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = StoragePool.themeSetting.isDarkMode;
    final primaryColor = StoragePool.themeSetting.color;
    final home = StoragePool.authSetting.currentUsername != null ? const HomePage() : const WelcomePage();

    return ScreenUtilInit(
      builder: () => DynamicColorTheme(
        data: (Color color, bool isDark) {
          return _buildTheme(context, color, isDark);
        },
        defaultColor: primaryColor,
        defaultIsDark: isDark,
        themedWidgetBuilder: (BuildContext context, ThemeData theme) => MaterialApp(
          navigatorKey: Catcher.navigatorKey,
          title: '上应小风筝',
          theme: theme,
          home: home,
          onGenerateRoute: _onGenerateRoute,
          builder: (context, widget) {
            ScreenUtil.setContext(context);
            return widget!;
          },
        ),
      ),
    );
  }
}
