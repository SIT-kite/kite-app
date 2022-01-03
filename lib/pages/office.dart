import 'package:flutter/material.dart';

class OfficePage extends StatefulWidget {
  const OfficePage({Key? key}) : super(key: key);

  @override
  _OfficePageState createState() => _OfficePageState();
}

class _OfficePageState extends State<OfficePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('办公')),
      body: SafeArea(child: ListView()),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        tooltip: '我的消息',
        child: const Icon(Icons.mail_outline),
      ),
    );
  }
}
