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
import 'package:kite/route.dart';

import 'feature/page_index.dart';
import 'global/global.dart';
import 'setting/init.dart';
import 'util/logger.dart';

const title = '上应小风筝';

class KiteApp extends StatelessWidget {
  const KiteApp({Key? key}) : super(key: key);

  Route<dynamic> _onGenerateRoute(RouteSettings settings) {
    Log.info('跳转路由: ${settings.name}');
    Global.pageLogger.page(settings.name ?? 'Unknown');
    return MaterialPageRoute(
      builder: (context) => RouteTable.get(settings.name!)!(context),
      settings: settings,
    );
  }

  TextTheme _buildTextTheme(bool isDark, Color primaryColor) {
    final fullColor = isDark ? Colors.white : Colors.black;
    final halfColor = isDark ? Colors.white70 : Colors.black87;
    // final lightColor = isDark ? Colors.white60 : Colors.black54;

    return TextTheme(
      // https://material.io/design/typography/the-type-system.html
      // https://www.mdui.org/design/style/typography.html
      // 12、14、16、20
      headline1: TextStyle(fontSize: 24.0, color: fullColor, fontWeight: FontWeight.w500),
      headline2: TextStyle(fontSize: 20.0, color: fullColor),
      headline3: TextStyle(fontSize: 20.0, color: halfColor, fontWeight: FontWeight.w500),
      headline4: TextStyle(fontSize: 20.0, color: halfColor),
      headline5: TextStyle(fontSize: 24.0, color: fullColor),
      headline6: TextStyle(fontSize: 20.0, color: fullColor, fontWeight: FontWeight.w500),
      subtitle1: TextStyle(fontSize: 18.0, color: halfColor, fontWeight: FontWeight.w500),
      subtitle2: TextStyle(fontSize: 16.0, color: halfColor, fontWeight: FontWeight.w500),
      bodyText1: TextStyle(fontSize: 16.0, color: fullColor),
      bodyText2: TextStyle(fontSize: 14.0, color: fullColor),
      caption: TextStyle(fontSize: 12.0, color: halfColor),

      // headline1: TextStyle(fontSize: 30.0, color: fullColor, fontWeight: FontWeight.w500),
      // headline2: TextStyle(fontSize: 28.0, color: fullColor),
      // headline3: TextStyle(fontSize: 24.0, color: halfColor),
      // headline4: TextStyle(fontSize: 22.0, color: halfColor, fontWeight: FontWeight.w500),
      // headline5: TextStyle(fontSize: 20.0, color: lightColor, fontWeight: FontWeight.w400),
      // headline6: TextStyle(fontSize: 18.0, color: lightColor, fontWeight: FontWeight.w500),
      // bodyText1: TextStyle(fontSize: 16.0, color: lightColor),
      // bodyText2: TextStyle(fontSize: 14.0, color: lightColor),
    );
  }

  ThemeData _buildTheme(BuildContext context, Color primaryColor, bool isDark) {
    const scaffoldBackgroundColorGrey = 245;
    return ThemeData(
      colorSchemeSeed: primaryColor,
      textTheme: _buildTextTheme(isDark, primaryColor),
      brightness: isDark ? Brightness.dark : Brightness.light,
      useMaterial3: true,
      scaffoldBackgroundColor: isDark
          ? null
          : const Color.fromARGB(
              255,
              scaffoldBackgroundColorGrey,
              scaffoldBackgroundColorGrey,
              scaffoldBackgroundColorGrey,
            ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = SettingInitializer.theme.isDarkMode;
    final primaryColor = SettingInitializer.theme.color;
    final home = SettingInitializer.auth.currentUsername != null ? const HomePage() : const WelcomePage();

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
