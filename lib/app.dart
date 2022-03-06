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
import 'package:catcher/core/catcher.dart';
import 'package:dynamic_color_theme/dynamic_color_theme.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kite/global/storage_pool.dart';
import 'package:kite/page/index.dart';
import 'package:kite/util/logger.dart';
import 'package:kite/util/page_logger.dart';

const title = '上应小风筝';

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
  '/game': (context) => GamePage(),
  '/game/2048': (context) => Game2048Page(),
  '/game/wordle': (context) => WordlePage(),
  '/wiki': (context) => WikiPage(),
  '/library': (context) => const LibraryPage(),
  '/market': (context) => const MarketPage(),
  '/timetable': (context) => const TimetablePage(),
  '/timetable/import': (context) => const TimetableImportPage(),
  '/setting': (context) => SettingPage(),
  '/feedback': (context) => const FeedbackPage(),
  '/notice': (context) => const NoticePage(),
  '/contact': (context) => const ContactPage(),
  '/bulletin': (context) => const BulletinPage(),
  '/mail': (context) => const MailPage(),
  '/night': (context) => const NightPage(),
  '/event': (context) => const EventPage(),
  '/lost-found': (context) => const LostFoundPage(),
  '/classroom': (context) => const ClassroomPage(),
  '/exam': (context) => const ExamPage(),
  '/egg': (context) => const EggPage(),
};

class KiteApp extends StatelessWidget {
  const KiteApp({Key? key}) : super(key: key);

  Route<dynamic> _onGenerateRoute(RouteSettings settings) {
    Log.info('跳转路由: ${settings.name}');
    pageLogger.page(settings.name ?? 'Unknown');
    return MaterialPageRoute(
      builder: (context) => _routes[settings.name]!(context),
      settings: settings,
    );
  }

  TextTheme _buildTextTheme(Color primaryColor) {
    return const TextTheme(
      headline1: TextStyle(fontSize: 24.0, fontWeight: FontWeight.w500),
      headline2: TextStyle(fontSize: 24.0, color: Colors.black87),
      headline3: TextStyle(fontSize: 24.0, color: Colors.black54),
      headline4: TextStyle(fontSize: 22.0, fontWeight: FontWeight.w500),
      headline5: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w400),
      headline6: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w300),
      bodyText1: TextStyle(fontSize: 16.0, color: Colors.black87),
      bodyText2: TextStyle(fontSize: 14.0, color: Colors.black54),

      // https://www.mdui.org/design/style/typography.html
      // 12、14、16、20
      // title: /*     */ TextStyle(fontSize: 20.0, fontWeight: FontWeight.w500),
      // subheading: /**/ TextStyle(fontSize: 16.0, color: Colors.black87),
      // body1: /*     */ TextStyle(fontSize: 14.0),
      // body2: /*     */ TextStyle(fontSize: 14.0, fontWeight: FontWeight.w500),
      // caption: /*   */ TextStyle(fontSize: 12.0, color: Colors.black87),
    );
  }

  ThemeData _buildTheme(BuildContext context, Color primaryColor, bool isDark) {
    return ThemeData(
      colorSchemeSeed: primaryColor,
      textTheme: _buildTextTheme(primaryColor),
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
        defaultColor: primaryColor,
        defaultIsDark: isDark,
        data: (Color color, bool isDark) {
          return _buildTheme(context, color, isDark);
        },
        themedWidgetBuilder: (BuildContext context, ThemeData theme) {
          return KeyboardListener(
            onKeyEvent: (event) {
              Log.info('按键事件: ${event.logicalKey}');

              if (event is KeyUpEvent && LogicalKeyboardKey.escape == event.logicalKey) {
                Log.info('松开返回键');
                final ctx = Catcher.navigatorKey?.currentContext;
                if (ctx != null && Navigator.canPop(ctx)) {
                  Navigator.pop(ctx);
                }
              }
            },
            focusNode: FocusNode(),
            child: MaterialApp(
              title: title,
              theme: theme,
              home: home,
              debugShowCheckedModeBanner: false,
              navigatorKey: Catcher.navigatorKey,
              onGenerateRoute: _onGenerateRoute,
              builder: (context, widget) {
                ScreenUtil.setContext(context);
                return MediaQuery(
                  // 设置文字大小不随系统设置改变
                  data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                  child: widget!,
                );
              },
              scrollBehavior: const MaterialScrollBehavior().copyWith(
                dragDevices: {
                  PointerDeviceKind.mouse,
                  PointerDeviceKind.touch,
                  PointerDeviceKind.stylus,
                  PointerDeviceKind.unknown
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
