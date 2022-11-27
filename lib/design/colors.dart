import 'package:flutter/material.dart';
import 'package:kite/design/utils.dart';

Color getThemeColor(BuildContext ctx) {
  var theme = Theme.of(ctx);
  if (theme.isLight) {
    return theme.primaryColor;
  } else {
    return theme.colorScheme.onPrimary;
  }
}

extension DesignExtension on BuildContext {
  Color get themeColor => getThemeColor(this);
}

class ColorPair {
  final Color light;
  final Color dark;

  const ColorPair(this.light, this.dark);
}

/// https://m3.material.io/theme-builder#/custom
class CourseColor {
  /// Raw color is in HTC
  static const List<ColorPair> all = [
    ColorPair(Color(0xFF85e779), Color(0xFF16520f)), // green #678a5c
    ColorPair(Color(0xFFc3e8ff), Color(0xFF004c68)), // sky #5487a3
    ColorPair(Color(0xFFffd9e2), Color(0xFF7b294a)), // pink #ae6f83
    ColorPair(Color(0xFFad9bd7), Color(0xFF50378a)), // violet #8879ab
    ColorPair(Color(0xFFff9d6b), Color(0xFF7f2b00)), // orange #a23900
    ColorPair(Color(0xFFffa2d2), Color(0xFF8e004a)), // rose #b50060
    ColorPair(Color(0xFFfbe365), Color(0xFF524700)), // lemon #b09e40
    ColorPair(Color(0xFF75f8e2), Color(0xFF005047)), // cyan #008f7f
  ];

  static get({required ThemeData from, required int by}) {
    final pair = all[by.abs() % all.length];
    if (from.brightness == Brightness.light) {
      return pair.light;
    } else {
      return pair.dark;
    }
  }
}
