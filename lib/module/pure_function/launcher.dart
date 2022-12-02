import 'package:flutter/material.dart';
import 'package:kite/launcher.dart';

class LauncherFunction extends StatelessWidget {
  final String schemeText;
  const LauncherFunction(this.schemeText, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    GlobalLauncher.launch(schemeText);
    Navigator.of(context).pop();
    return Container();
  }
}
