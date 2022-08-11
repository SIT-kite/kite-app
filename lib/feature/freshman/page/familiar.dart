import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../dao.dart';
import '../init.dart';

class FreshmanFamiliarPage extends StatefulWidget {
  const FreshmanFamiliarPage({Key? key}) : super(key: key);

  @override
  State<FreshmanFamiliarPage> createState() => _FreshmanFamiliarPageState();
}

class _FreshmanFamiliarPageState extends State<FreshmanFamiliarPage> {
  final FreshmanDao freshmanDao = FreshmanInitializer.freshmanDao;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [Text('ACV')],
      ),
    );
  }
}
