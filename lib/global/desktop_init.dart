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
import 'package:kite/common/annotation.dart';
import 'package:kite/r.dart';
import 'package:kite/storage/init.dart';
import 'package:kite/util/event_bus.dart';
import 'package:universal_platform/universal_platform.dart';
import 'package:window_manager/window_manager.dart';

enum WindowEvent {
  onWindowResize,
  onWindowResized,
}

class MyWindowListener extends WindowListener {
  final EventBus<WindowEvent> eventBus;

  MyWindowListener({required this.eventBus});

  @override
  void onWindowResize() async {
    final size = await windowManager.getSize();
    eventBus.emit<Size>(WindowEvent.onWindowResize, size);
    Kv.theme.lastWindowSize = size;
  }

  @override
  void onWindowResized() async {
    final size = await windowManager.getSize();
    eventBus.emit(WindowEvent.onWindowResized);
    Kv.theme.lastWindowSize = size;
  }
}

class DesktopInit {
  static bool resizing = false;
  static EventBus<WindowEvent> eventBus = EventBus<WindowEvent>();

  static Future<void> init() async {
    windowManager.addListener(MyWindowListener(eventBus: eventBus));
    eventBus.on(WindowEvent.onWindowResize, (args) => resizing = true);
    eventBus.on(WindowEvent.onWindowResized, (args) => resizing = false);
    // 必须加上这一行。
    await windowManager.ensureInitialized();
    windowManager.waitUntilReadyToShow().then((_) async {
      // Hide window title bar
      await windowManager.setSize(R.defaultWindowSize);
      // Center the window.
      await windowManager.center();
      await windowManager.setMinimumSize(R.minWindowSize);
      await windowManager.show();
    });
  }

  static Future<void> resizeTo(Size newSize, {bool center = false}) async {
    await windowManager.setSize(newSize);
    if (center) {
      await windowManager.center();
    }
  }

  @desktopSafe
  static setTitle(String title) async {
    if (UniversalPlatform.isDesktop) {
      await windowManager.setTitle(title);
    }
  }
}
