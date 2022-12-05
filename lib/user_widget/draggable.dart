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
import 'package:rettulf/rettulf.dart';

typedef KeyWidgetBuilder = Widget Function(BuildContext ctx, Key key);

class OmniDraggable extends StatefulWidget {
  final Offset offset;
  final Widget child;

  const OmniDraggable({super.key, required this.child, this.offset = Offset.zero});

  @override
  State<OmniDraggable> createState() => _OmniDraggableState();
}

class _OmniDraggableState extends State<OmniDraggable> with SingleTickerProviderStateMixin {
  var _x = 0.0;
  var _y = 0.0;
  final childKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final ctx = childKey.currentContext;
      if (ctx != null) {
        final box = ctx.findRenderObject();
        if (box is RenderBox) {
          final childSize = box.size;
          final selfSize = context.mediaQuery.size;
          setState(() {
            _x = (selfSize.width - childSize.width) / 2 + widget.offset.dx;
            _y = (selfSize.height - childSize.height) / 2 + widget.offset.dy;
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return [
      Positioned(
          left: _x,
          top: _y,
          child: Listener(
            key: childKey,
            child: widget.child,
            onPointerMove: (d) {
              setState(() {
                _x += d.delta.dx;
                _y += d.delta.dy;
              });
            },
          ))
    ].stack();
  }
}
