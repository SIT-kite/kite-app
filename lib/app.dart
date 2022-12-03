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
import 'dart:convert';
import 'dart:ui';

import 'package:animations/animations.dart';
import 'package:catcher/core/catcher.dart';
import 'package:dynamic_color_theme/dynamic_color_theme.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kite/l10n/extension.dart';
import 'package:kite/override/entity.dart';
import 'package:kite/route.dart';
import 'package:rettulf/rettulf.dart';

import 'global/desktop_initializer.dart';
import 'global/global.dart';
import 'navigation/route.dart';
import 'storage/init.dart';
import 'util/logger.dart';

class KiteApp extends StatefulWidget {
  const KiteApp({Key? key}) : super(key: key);

  @override
  State<KiteApp> createState() => _KiteAppState();
}

class _KiteAppState extends State<KiteApp> {
  // 先使用默认的路由表
  IRouteGenerator routeGenerator = defaultRouteTable;

  @override
  void initState() {
    super.initState();
    // Initialize the app with system theme.
    var platformBrightness = SchedulerBinding.instance.platformDispatcher.platformBrightness;
    Kv.theme.isDarkMode ??= platformBrightness == Brightness.dark;
  }

  Route<dynamic> _onGenerateRoute(RouteSettings settings) {
    return MaterialPageRoute(
      builder: (context) {
        final args = settings.arguments as Map<String, dynamic>? ?? {};
        final argsJson = jsonEncode(args);
        if (!DesktopInit.resizing) {
          Log.info('跳转路由: ${settings.name}, 参数: $argsJson');
          Global.pageLogger.page(settings.name ?? 'Unknown', argsJson);
        }
        return routeGenerator.onGenerateRoute(settings.name!, args)(context);
      },
      settings: settings,
    );
  }

  TextTheme _buildTextTheme(bool isDark, Color primaryColor) {
    final fullColor = isDark ? Colors.white : Colors.black;
    final halfColor = isDark ? Colors.white70 : Colors.black87;

    return TextTheme(
      // https://material.io/design/typography/the-type-system.html
      // https://www.mdui.org/design/style/typography.html
      // 12、14、16、20
      headline1: TextStyle(fontSize: 24.0, color: fullColor, fontWeight: FontWeight.w500),
      headline2: TextStyle(fontSize: 22.0, color: fullColor),
      headline3: TextStyle(fontSize: 20.0, color: halfColor, fontWeight: FontWeight.w500),
      headline4: TextStyle(fontSize: 20.0, color: halfColor),
      headline5: TextStyle(fontSize: 24.0, color: fullColor),
      headline6: TextStyle(fontSize: 20.0, color: fullColor, fontWeight: FontWeight.w500),
      subtitle1: TextStyle(fontSize: 18.0, color: halfColor, fontWeight: FontWeight.w500),
      subtitle2: TextStyle(fontSize: 16.0, color: halfColor, fontWeight: FontWeight.w500),
      bodyText1: TextStyle(fontSize: 16.0, color: fullColor),
      bodyText2: TextStyle(fontSize: 14.0, color: fullColor),
      caption: TextStyle(fontSize: 12.0, color: halfColor),
    );
  }

  ThemeData _buildTheme(BuildContext context, Color primaryColor, bool isDark) {
    const grey = 245;
    return ThemeData(
      colorSchemeSeed: primaryColor,
      textTheme: _buildTextTheme(isDark, primaryColor),
      brightness: isDark ? Brightness.dark : Brightness.light,
      useMaterial3: true,
      scaffoldBackgroundColor: isDark ? null : const Color.fromARGB(255, grey, grey, grey),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Kv.theme.isDarkMode ?? false;
    final primaryColor = Kv.theme.color;

    // refresh override route
    Global.eventBus.on(EventNameConstants.onRouteRefresh, (arg) {
      final FunctionOverrideInfo overrideInfo = arg! as FunctionOverrideInfo;
      // 路由公告
      routeGenerator = RouteWithNoticeDialog(
        Catcher.navigatorKey!.currentContext!,
        routeNotice: overrideInfo.routeNotice,
        // 路由覆盖
        routeGenerator: DefaultRouteWithOverride(
          defaultRoute: defaultRouteTable, // 静态路由
          overrideItems: overrideInfo.routeOverride,
        ),
      );
    });
    buildMaterialWithTheme(ThemeData theme) {
      return MaterialApp(
        title: R.getAppName(by: window.locale),
        theme: theme.copyWith(
            pageTransitionsTheme: const PageTransitionsTheme(
              builders: {
                TargetPlatform.android: CupertinoPageTransitionsBuilder(),
                TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
                TargetPlatform.macOS: CupertinoPageTransitionsBuilder(),
                TargetPlatform.linux: FadeThroughPageTransitionsBuilder(),
                TargetPlatform.windows: FadeThroughPageTransitionsBuilder(),
              },
            ),
            visualDensity: VisualDensity.comfortable),
        initialRoute: RouteTable.root,
        debugShowCheckedModeBanner: false,
        navigatorKey: Catcher.navigatorKey,
        onGenerateRoute: _onGenerateRoute,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: Lang.supports,
        locale: Kv.pref.locale,
        builder: EasyLoading.init(builder: (context, widget) {
          // A workaround to get the system locale.
          final systemLocale = Localizations.localeOf(context);
          Lang.setCurrentLocaleIfAbsent(systemLocale);
          Future.delayed(Duration.zero, () async => await DesktopInit.setTitle(i18n.appName));
          if (context.isPortrait) {
            SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
                overlays: [SystemUiOverlay.top, SystemUiOverlay.bottom]);
          } else {
            SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [SystemUiOverlay.bottom]);
          }
          return MediaQuery(
            // 设置文字大小不随系统设置改变
            data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
            child: widget!,
          );
        }),
        scrollBehavior: const MaterialScrollBehavior().copyWith(
          dragDevices: {
            PointerDeviceKind.mouse,
            PointerDeviceKind.touch,
            PointerDeviceKind.stylus,
            PointerDeviceKind.trackpad,
            PointerDeviceKind.unknown
          },
        ),
      );
    }

    buildWidgetWithKeyboardListener(Widget child) {
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
        child: child,
      );
    }

    return ScreenUtilInit(
      builder: (BuildContext content, Widget? widget) => DynamicColorTheme(
        defaultColor: primaryColor,
        defaultIsDark: isDark,
        data: (Color color, bool isDark) {
          return _buildTheme(context, color, isDark);
        },
        themedWidgetBuilder: (BuildContext context, ThemeData theme) {
          return buildWidgetWithKeyboardListener(buildMaterialWithTheme(theme));
        },
      ),
    );
  }
}
