import 'package:flutter/material.dart';

import '../dao.dart';
import '../init.dart';

class FreshmanAnalysisPage extends StatefulWidget {
  const FreshmanAnalysisPage({Key? key}) : super(key: key);

  @override
  State<FreshmanAnalysisPage> createState() => _FreshmanAnalysisPageState();
}

class _FreshmanAnalysisPageState extends State<FreshmanAnalysisPage> {
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
