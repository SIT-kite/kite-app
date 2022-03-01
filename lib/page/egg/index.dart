import 'package:flutter/material.dart';

import 'time_widget.dart';

class EggPage extends StatelessWidget {
  const EggPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RotatedBox(
      quarterTurns: 1,
      child: TimeWidget(),
    );
  }
}
