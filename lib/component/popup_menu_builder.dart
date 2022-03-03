import 'package:flutter/material.dart';

class _PopupMenuItem {
  PopupMenuEntry popupMenuEntry;
  VoidCallback? onTap;
  _PopupMenuItem({
    required this.popupMenuEntry,
    this.onTap,
  });
}

class SimplePopupMenuButtonBuilder {
  final List<_PopupMenuItem> popupMenuItems = [];
  SimplePopupMenuButtonBuilder add(
    Widget child, {
    VoidCallback? onTap,
  }) {
    popupMenuItems.add(_PopupMenuItem(
      popupMenuEntry: PopupMenuItem(
        child: child,
        value: popupMenuItems.length,
      ),
      onTap: onTap,
    ));
    return this;
  }

  PopupMenuButton build() {
    return PopupMenuButton(
      onSelected: (index) {
        final cb = popupMenuItems[index].onTap;
        if (cb != null) cb();
      },
      itemBuilder: (context) => popupMenuItems.map((e) => e.popupMenuEntry).toList(),
    );
  }
}
