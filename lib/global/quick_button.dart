import 'package:flutter/material.dart';
import 'package:quick_actions/quick_actions.dart';

class QuickButton {
  static BuildContext? _context;
  static const QuickActions _quickActions = QuickActions();

  static void quickActionHandler(String type) {
    if (type == 'report') {
      Navigator.of(_context!).pushNamed('/report');
    } else if (type == 'timetable') {
      Navigator.of(_context!).pushNamed('/timetable');
    }
  }

  static void init(BuildContext context) {
    _context = context;
    _quickActions.initialize(quickActionHandler);

    _quickActions.setShortcutItems(<ShortcutItem>[
      const ShortcutItem(type: 'report', localizedTitle: '体温上报', icon: null),
      const ShortcutItem(type: 'timetable', localizedTitle: '课表', icon: null)
    ]);
  }
}
