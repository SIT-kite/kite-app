import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../dao.dart';
import '../init.dart';

class FreshmanInfoPage extends StatefulWidget {
  FreshmanDao freshmanDao = FreshmanInitializer.freshmanDao;

  FreshmanInfoPage({Key? key}) : super(key: key);

  @override
  State<FreshmanInfoPage> createState() => _FreshmanInfoPageState();
}

class _FreshmanInfoPageState extends State<FreshmanInfoPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [Text('ACV')],
      ),
    );
  }
}
