import 'package:flutter/material.dart';

typedef NamedRouteBuilder = Widget Function(
  BuildContext context,
  Map<String, dynamic> args,
);
typedef NotFoundRouteBuilder = Widget Function(
  BuildContext context,
  String routeName,
  Map<String, dynamic> args,
);
typedef RootRouteBuilder = Widget Function(
  BuildContext context,
  StaticRouteTable table,
  Map<String, dynamic> args,
);

abstract class IRouteGenerator {
  // 判定该路由生成器是否能够生成指定路由名的路由
  bool accept(String routeName);
  WidgetBuilder onGenerateRoute(String routeName, Map<String, dynamic> arguments);
}

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
