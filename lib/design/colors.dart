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
extension DesignExtension on BuildContext{
  Color get themeColor => getThemeColor(this);

}