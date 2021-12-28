// import 'dart:io';

import 'package:flutter/material.dart';

class FunctionItemWidget extends StatelessWidget {
  final String routeName;
  final Widget icon;
  final String text;
  const FunctionItemWidget(this.routeName, this.icon, this.text, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.black,
            width: 3,
            style: BorderStyle.solid,
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: this.icon,
              flex: 3,
            ),
            Expanded(child: Text(this.text)),
          ],
        ),
      ),
      onTap: () {
        Navigator.pushNamed(context, this.routeName);
      },
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('主页'),
      ),
      body: GridView.extent(
        maxCrossAxisExtent: 150.0,
        padding: const EdgeInsets.all(4.0),
        crossAxisSpacing: 4.0,
        children: const [
          FunctionItemWidget('/dailyReport', Icon(Icons.access_alarm), '疫情上报'),
          FunctionItemWidget('/welcome', Icon(Icons.access_alarm), '欢迎页'),
          FunctionItemWidget('/login', Icon(Icons.access_alarm), '登录页'),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            label: '首页',
            icon: Icon(Icons.home_outlined),
          ),
          BottomNavigationBarItem(
            label: '我',
            icon: Icon(Icons.person_outline),
          )
        ],
      ),
    );
  }
}
