import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../dao.dart';
import '../init.dart';

class FreshmanAnalyticsPage extends StatefulWidget {
  FreshmanDao freshmanDao = FreshmanInitializer.freshmanDao;

  FreshmanAnalyticsPage({Key? key}) : super(key: key);

  @override
  State<FreshmanAnalyticsPage> createState() => _FreshmanAnalyticsPageState();
}

class _FreshmanAnalyticsPageState extends State<FreshmanAnalyticsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [Text('ACV')],
      ),
    );
  }
}
