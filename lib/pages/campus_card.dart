import 'package:flutter/material.dart';

class CampusCardPage extends StatefulWidget {
  CampusCardPage({Key? key}) : super(key: key);

  @override
  _CampusCardPageState createState() => _CampusCardPageState();
}

class _CampusCardPageState extends State<CampusCardPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Text(
              '请将卡片贴合到手机背面 NFC 读卡器处',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 40.0),
            Image(
                image: AssetImage('assets/campusCard/illustration.png'),
                height: 300,
                width: 300),
          ],
        ),
      ),
    );
  }
}
