import 'package:flutter/material.dart';
import 'package:kite_app/widget/report/report.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '上应小风筝',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const DailyReportWidget(),
    );
  }
}
