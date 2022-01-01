import 'package:flutter/material.dart';
import 'package:kite/pages/about.dart';
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
      '/login': (context) => const LoginPage(),
      '/welcome': (context) => const WelcomePage(),
      '/about': (context) => const AboutPage(),
    };

    return MaterialApp(
      title: '上应小风筝',
      theme: ThemeData.light(),
      home: const AboutPage(),
      routes: routes,
    );
  }
}
