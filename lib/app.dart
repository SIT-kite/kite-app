import 'package:flutter/material.dart';
import 'package:kite/page/about.dart';
import 'package:kite/page/campus_card.dart';
import 'package:kite/page/connectivity.dart';
import 'package:kite/page/electricity.dart';
import 'package:kite/page/expense.dart';
import 'package:kite/page/game.dart';
import 'package:kite/page/home.dart';
import 'package:kite/page/library/library.dart';
import 'package:kite/page/login.dart';
import 'package:kite/page/makert.dart';
import 'package:kite/page/office.dart';
import 'package:kite/page/report.dart';
import 'package:kite/page/score.dart';
import 'package:kite/page/timetable/timetable.dart';
import 'package:kite/page/welcome.dart';
import 'package:kite/page/wiki.dart';
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
      '/expense': (context) => ExpensePage(),
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
    };

    return MaterialApp(
      title: '上应小风筝',
      theme: ThemeData.light(),
      debugShowCheckedModeBanner: false,
      home: StoragePool.auth.hasUsername ? HomePage() : const WelcomePage(),
      routes: routes,
    );
  }
}
