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
  '/game': (context) => const GamePage(),
  '/wiki': (context) => const WikiPage(),
  '/library': (context) => const LibraryPage(),
  '/market': (context) => const MarketPage(),
  '/timetable': (context) => const TimetablePage(),
  '/setting': (context) => const SettingPage(),
  '/feedback': (context) => const FeedbackPage(),
  '/notice': (context) => const NoticePage(),
  '/contact': (context) => const ContactPage(),
  '/bulletin': (context) => const BulletinPage(),
  '/mail': (context) => MailPage(),
};

class KiteApp extends StatelessWidget {
  const KiteApp({Key? key}) : super(key: key);

  MaterialColor _createThemeSwatch(Color color) {
    List strengths = <double>[.05];
    Map<int, Color> swatch = {};
    final int r = color.red, g = color.green, b = color.blue;

    for (int i = 1; i < 10; i++) {
      strengths.add(0.1 * i);
    }
    for (var strength in strengths) {
      final double ds = 0.5 - strength;
      swatch[(strength * 1000).round()] = Color.fromRGBO(
        r + ((ds < 0 ? r : (255 - r)) * ds).round(),
        g + ((ds < 0 ? g : (255 - g)) * ds).round(),
        b + ((ds < 0 ? b : (255 - b)) * ds).round(),
        1,
      );
    }
    return MaterialColor(color.value, swatch);
  }

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
