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

mixin OverlayStateMixin<T extends StatefulWidget> on State<T> {
  // 2
  OverlayEntry? _overlayEntry;

  void removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  void insertOverlay(Widget child) {
    if (_overlayEntry == null) {
      _overlayEntry = OverlayEntry(
        builder: (_) => child,
      );
      Overlay.of(context)?.insert(_overlayEntry!);
    }
  }
}
