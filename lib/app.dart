import 'package:flutter/material.dart';
import 'package:kite/global/storage_pool.dart';
import 'package:kite/page/index.dart';

class KiteApp extends StatelessWidget {
  const KiteApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final routes = {
      '/home': (context) => HomePage(),
      '/report': (context) => const DailyReportPage(),
      '/login': (context) => const LoginPage(),
      '/welcome': (context) => const WelcomePage(),
      '/about': (context) => const AboutPage(),
      '/expense': (context) => const ExpensePage(),
      '/connectivity': (context) => ConnectivityPage(),
      '/campusCard': (context) => const CampusCardPage(),
      '/electricity': (context) => const ElectricityPage(),
      '/score': (context) => const ScorePage(),
      '/office': (context) => const OfficePage(),
      '/game': (context) => const GamePage(),
      '/wiki': (context) => const WikiPage(),
      '/library': (context) => const LibraryPage(),
      '/market': (context) => const MarketPage(),
      '/timetable': (context) => const TimetablePage(),
      '/setting': (context) => const SettingPage(),
    };

    // primarySwatch should be set, by https://github.com/flutter/flutter/issues/82996.
    final primaryColor = StoragePool.themeSetting.color;
    final themeData = ThemeData(primaryColor: primaryColor, primarySwatch: createThemeSwatch(primaryColor));

    return MaterialApp(
      title: '上应小风筝',
      theme: themeData,
      debugShowCheckedModeBanner: false,
      home: StoragePool.authSetting.currentUsername != null ? HomePage() : const WelcomePage(),
      routes: routes,
    );
  }
}

MaterialColor createThemeSwatch(Color color) {
  List strengths = <double>[.05];
  Map<int, Color> swatch = {};
  final int r = color.red, g = color.green, b = color.blue;

  for (int i = 1; i < 10; i++) {
    strengths.add(0.1 * i);
  }
  strengths.forEach((strength) {
    final double ds = 0.5 - strength;
    swatch[(strength * 1000).round()] = Color.fromRGBO(
      r + ((ds < 0 ? r : (255 - r)) * ds).round(),
      g + ((ds < 0 ? g : (255 - g)) * ds).round(),
      b + ((ds < 0 ? b : (255 - b)) * ds).round(),
      1,
    );
  });
  return MaterialColor(color.value, swatch);
}
