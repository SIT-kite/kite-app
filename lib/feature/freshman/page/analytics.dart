import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../dao.dart';
import '../init.dart';

class FreshmanAnalyticsPage extends StatefulWidget {
  const FreshmanAnalyticsPage({Key? key}) : super(key: key);

  @override
  State<FreshmanAnalyticsPage> createState() => _FreshmanAnalyticsPageState();
}

class _FreshmanAnalyticsPageState extends State<FreshmanAnalyticsPage> {
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
