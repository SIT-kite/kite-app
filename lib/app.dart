import 'package:flutter/material.dart';
import 'package:kite/pages/login.dart';
import 'package:kite/pages/home.dart';
import 'package:kite/pages/report.dart';
import 'package:kite/pages/welcome.dart';

class KiteApp extends StatelessWidget {
  const KiteApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final routes = {
      '/home': (context) => HomePage(),
      '/dailyReport': (context) => const DailyReportPage(),
      '/login': (context) => LoginPage(),
      '/welcome': (context) => WelcomePage(),
    };

    return MaterialApp(
      title: '上应小风筝',
      theme: ThemeData.light(),
      home: const WelcomePage(),
      routes: routes,
    );
  }
}
