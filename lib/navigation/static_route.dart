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
import 'package:flutter/widgets.dart';
import 'package:kite/navigation/route.dart';

typedef RootRouteBuilder = Widget Function(
  BuildContext context,
  StaticRouteTable table,
  Map<String, dynamic> args,
);

class StaticRouteTable implements IRouteGenerator {
  final Map<String, NamedRouteBuilder> table;
  final NotFoundRouteBuilder onNotFound;
  final RootRouteBuilder? rootRoute;

  StaticRouteTable({
    required this.table,
    required this.onNotFound,
    this.rootRoute,
  });

  @override
  bool accept(String routeName) => routeName == '/' || table.containsKey(routeName);

  @override
  WidgetBuilder onGenerateRoute(String routeName, Map<String, dynamic> arguments) {
    return (context) {
      if (routeName == '/' && rootRoute != null) {
        return rootRoute!(context, this, arguments);
      }
      if (table.containsKey(routeName)) {
        return table[routeName]!(context, arguments);
      } else {
        return onNotFound(context, routeName, arguments);
      }
    };
  }
}
