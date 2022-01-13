import 'package:flutter/material.dart';
import 'package:kite/pages/about.dart';
import 'package:kite/pages/campus_card.dart';
import 'package:kite/pages/connectivity.dart';
import 'package:kite/pages/electricity.dart';
import 'package:kite/pages/expense.dart';
import 'package:kite/pages/game.dart';
import 'package:kite/pages/home.dart';
import 'package:kite/pages/login.dart';
import 'package:kite/pages/office.dart';
import 'package:kite/pages/report.dart';
import 'package:kite/pages/score.dart';
import 'package:kite/pages/welcome.dart';
import 'package:kite/storage/auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    };

    return MaterialApp(
      title: '上应小风筝',
      theme: ThemeData.light(),
      home: FutureBuilder<SharedPreferences>(
        future: SharedPreferences.getInstance(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          // 请求已结束
          if (snapshot.connectionState == ConnectionState.done) {
            SharedPreferences prefs = snapshot.data;
            // 若用户使用过，那么直接跳转到首页
            if (AuthStorage(prefs).hasUsername) {
              return HomePage();
            } else {
              return const WelcomePage();
            }
          } else {
            // 请求未结束，白屏
            return Container();
          }
        },
      ),
      routes: routes,
    );
  }
}
