import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../dao.dart';
import '../init.dart';

class FreshmanFriendPage extends StatefulWidget {
  FreshmanDao freshmanDao = FreshmanInitializer.freshmanDao;

  FreshmanFriendPage({Key? key}) : super(key: key);

  @override
  State<FreshmanFriendPage> createState() => _FreshmanFriendPageState();
}

class _FreshmanFriendPageState extends State<FreshmanFriendPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [Text('ACV')],
      ),
    );
  }
}
