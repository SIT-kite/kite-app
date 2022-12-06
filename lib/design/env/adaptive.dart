/*
 *    上应小风筝(SIT-kite)  便利校园，一步到位
 *    Copyright (C) 2022 上海应用技术大学 上应小风筝团队
 *
 *    This program is free software: you can redistribute it and/or modify
 *    it under the terms of the GNU General Public License as published by
 *    the Free Software Foundation, either version 3 of the License, or
 *    (at your option) any later version.
 *
 *    This program is distributed in the hope that it will be useful,
 *    but WITHOUT ANY WARRANTY; without even the implied warranty of
 *    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *    GNU General Public License for more details.
 *
 *    You should have received a copy of the GNU General Public License
 *    along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/
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
