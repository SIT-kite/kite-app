import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../dao.dart';
import '../init.dart';

class FreshmanClassPage extends StatefulWidget {
  FreshmanDao freshmanDao = FreshmanInitializer.freshmanDao;

  FreshmanClassPage({Key? key}) : super(key: key);

  @override
  State<FreshmanClassPage> createState() => _FreshmanClassPageState();
}

class _FreshmanClassPageState extends State<FreshmanClassPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [Text('ACV')],
      ),
    );
  }
}
