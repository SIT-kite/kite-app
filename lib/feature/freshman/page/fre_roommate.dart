import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../dao.dart';
import '../init.dart';

class FreshmanRoommatePage extends StatefulWidget {
  FreshmanDao freshmanDao = FreshmanInitializer.freshmanDao;

  FreshmanRoommatePage({Key? key}) : super(key: key);

  @override
  State<FreshmanRoommatePage> createState() => _FreshmanRoommatePageState();
}

class _FreshmanRoommatePageState extends State<FreshmanRoommatePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [Text('ACV')],
      ),
    );
  }
}
