import 'dart:io';

import 'package:flutter/material.dart';

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
        padding: EdgeInsets.all(4.0),
        crossAxisSpacing: 4.0,
        children: List.generate(9, (int index) {
          // return IconTextButton();
          return IconButton(
            onPressed: () {
              Navigator.pushNamed(context, '/report');
            },
            icon: Icon(Icons.health_and_safety_outlined),
            tooltip: '疫情上报',
          );
        }),
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
