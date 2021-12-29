import 'package:flutter/material.dart';
import 'package:kite/pages/login.dart';
import 'package:kite/pages/home.dart';
import 'package:kite/routes/welcome.dart';
import 'package:kite/pages/report.dart';


class KiteApp extends StatelessWidget {
  const KiteApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final routes = {
        '/home': (context) => const HomePage(),
        '/dailyReport': (context) => const DailyReportPage(),
        '/welcome': (context) => const IntroductionAnimationScreen(),
        '/login': (context) => const LoginPage(),
    };

    return MaterialApp(
      title: '上应小风筝',
      theme: ThemeData.light(),
      home: const HomePage(),
      routes: routes,
    );
  }
}
