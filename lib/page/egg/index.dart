import 'package:flutter/material.dart';
import 'package:universal_platform/universal_platform.dart';

import 'time_widget.dart';

class EggPage extends StatelessWidget {
  const EggPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return UniversalPlatform.isDesktopOrWeb
        ? TimeWidget()
        : RotatedBox(
            quarterTurns: 1,
            child: TimeWidget(),
          );
  }
}
