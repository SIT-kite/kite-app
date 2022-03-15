import 'package:flutter/material.dart';
import 'package:kite/util/event_bus.dart';
import 'package:window_manager/window_manager.dart';

enum WindowEvent {
  onWindowResize,
}

class MyWindowListener extends WindowListener {
  final EventBus<WindowEvent> eventBus;
  MyWindowListener({required this.eventBus});
  @override
  void onWindowResize() async {
    final size = await windowManager.getSize();
    eventBus.emit<Size>(WindowEvent.onWindowResize, size);
  }
}

class DesktopInitializer {
  static late EventBus<WindowEvent> eventBus;
  static late WindowListener windowListener;
  static Future<void> init() async {
    DesktopInitializer.eventBus = EventBus<WindowEvent>();
    windowListener = MyWindowListener(eventBus: eventBus);
    // 必须加上这一行。
    await windowManager.ensureInitialized();
    // 桌面端初始尺寸
    await windowManager.setSize(const Size(500, 800));
    windowManager.addListener(windowListener);
    await windowManager.show();
  }
}
