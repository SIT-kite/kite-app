import 'package:flutter/material.dart';
import 'package:kite/page/index.dart';
import 'package:kite/storage/storage_pool.dart';

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

    return MaterialApp(
      title: '上应小风筝',
      theme: ThemeData.light(),
      debugShowCheckedModeBanner: false,
      home: StoragePool.authSetting.currentUsername != null ? HomePage() : const WelcomePage(),
      routes: routes,
    );
  }
}
