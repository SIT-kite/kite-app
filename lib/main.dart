import 'package:flutter/material.dart';

import 'package:kite/routes/home.dart';
import 'package:kite/routes/welcome.dart';
import 'package:kite/routes/report.dart';

void main() => runApp(const KiteApp());

class KiteApp extends StatelessWidget {
  const KiteApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '上应小风筝',
      theme: ThemeData.light(),
      home: const HomePage(),
      routes: {
        '/home': (context) => const HomePage(),
        '/report': (context) => const DailyReportPage(),
        '/welcome': (context) => const IntroductionAnimationScreen(),
      },
    );
  }
}
