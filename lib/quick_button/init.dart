/*
 * 上应小风筝  便利校园，一步到位
 * Copyright (C) 2022 上海应用技术大学 上应小风筝团队
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */
import 'package:flutter/material.dart';
import 'package:kite/l10n/extension.dart';
import 'package:kite/launcher.dart';
import 'package:kite/route.dart';
import 'package:kite/util/logger.dart';
import 'package:kite/util/scanner.dart';
import 'package:quick_actions/quick_actions.dart';

class QuickButton {
  static BuildContext? _context;
  static const QuickActions _quickActions = QuickActions();

  static void quickActionHandler(String type) {
    if (type == 'reportTemp') {
      Navigator.of(_context!).pushNamed(RouteTable.reportTemp);
    } else if (type == 'timetable') {
      Navigator.of(_context!).pushNamed(RouteTable.timetable);
    } else if (type == 'library') {
      Navigator.of(_context!).pushNamed(RouteTable.library);
    } else if (type == 'scanner') {
      () async {
        final result = await scan(_context!);
        Log.info('扫码结果: $result');
        if (result != null) GlobalLauncher.launch(result);
      }();
    }
  }

  static void init(BuildContext context) {
    _context = context;
    _quickActions.initialize(quickActionHandler);
    // TODO: Add Icons
    _quickActions.setShortcutItems(<ShortcutItem>[
      ShortcutItem(type: 'reportTemp', localizedTitle: i18n.ftype_reportTemp, icon: null),
      ShortcutItem(type: 'timetable', localizedTitle: i18n.ftype_timetable, icon: null),
      ShortcutItem(type: 'library', localizedTitle: i18n.ftype_library, icon: null),
      ShortcutItem(type: 'scanner', localizedTitle: i18n.ftype_scanner, icon: null),
    ]);
  }
}
