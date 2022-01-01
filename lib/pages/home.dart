import 'package:flutter/material.dart';

import 'home/gretting.dart';
import 'home/item.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  Widget buildTitleLine() {
    return const Align(
      alignment: Alignment.centerRight,
      child: Text('上应小风筝',
          style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.fromLTRB(40, 30, 40, 0),
        child: Column(
          children: [
            buildTitleLine(),
            const SizedBox(height: 20.0),
            GreetingWidget(),
            const SizedBox(height: 20.0),
            Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: const [
                  ItemWidget('/dailyReport', Icon(Icons.access_alarm), '体温上报'),
                  ItemWidget('/welcome', Icon(Icons.access_alarm), '欢迎页'),
                  ItemWidget('/login', Icon(Icons.access_alarm), '登录页'),
                ]),
          ],
        ),
      )),
    );
  }
}
