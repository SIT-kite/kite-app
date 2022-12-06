import 'package:flutter/material.dart';

import '../user_widgets/route.dart';

class AdaptiveUI extends InheritedWidget {
  final bool hasTransition;

  const AdaptiveUI({super.key, required this.hasTransition, required super.child});

  @override
  bool updateShouldNotify(covariant AdaptiveUI oldWidget) {
    return hasTransition != oldWidget.hasTransition;
  }

  static AdaptiveUI of(BuildContext ctx) {
    final result = ctx.dependOnInheritedWidgetOfExactType<AdaptiveUI>();
    assert(result != null, 'No RouteType found in context');
    return result!;
  }

  Route<T> makeRoute<T>(
    WidgetBuilder builder, {
    RouteSettings? settings,
    bool maintainState = true,
    bool fullscreenDialog = false,
  }) {
    if (hasTransition) {
      return MaterialPageRoute<T>(
          builder: builder, settings: settings, maintainState: maintainState, fullscreenDialog: fullscreenDialog);
    } else {
      return NoTransitionPageRoute<T>(
          builder: builder, settings: settings, maintainState: maintainState, fullscreenDialog: fullscreenDialog);
    }
  }
}
