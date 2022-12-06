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
import 'package:rettulf/rettulf.dart';
import 'package:universal_platform/universal_platform.dart';

extension ScrollWidgetListEx on List<Widget> {
  Widget scrolledWithBar({Key? key, ScrollController? controller}) {
    if (UniversalPlatform.isWindows || UniversalPlatform.isLinux) {
      return listview();
    } else {
      return _KiteScrolledWithBar(
        key: key,
        controller: controller,
        children: this,
      );
    }
  }
}

extension ScrollSingleWidgetEx on Widget {
  Widget scrolledWithBar({Key? key, ScrollController? controller}) {
    if (UniversalPlatform.isWindows || UniversalPlatform.isLinux) {
      return scrolled();
    } else {
      return _KiteScrolledWithBar(
        key: key,
        controller: controller,
        child: this,
      );
    }
  }
}

class _KiteScrolledWithBar extends StatefulWidget {
  final Widget? child;
  final List<Widget>? children;
  final ScrollController? controller;

  const _KiteScrolledWithBar({super.key, this.child, this.children, this.controller})
      : assert(child != null || children != null);

  @override
  State<_KiteScrolledWithBar> createState() => _KiteScrolledWithBarState();
}

class _KiteScrolledWithBarState extends State<_KiteScrolledWithBar> {
  ScrollController? controller;

  @override
  void initState() {
    super.initState();
    final child = widget.child;
    if (child is ScrollView) {
      final childController = child.controller;
      assert(childController != null, "The ScrollView external provided should have a ScrollController.");
      controller = child.controller;
    } else {
      controller = widget.controller ?? ScrollController();
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (ctx, constraints) {
        final width = constraints.maxWidth;
        var child = widget.child;
        final children = widget.children;
        if (child != null) {
          // child mode
          if (child is! ScrollView) {
            child = child.scrolled(controller: controller);
          }
        } else if (children != null) {
          // list mode
          child = children.listview(controller: controller);
        } else {
          throw Exception("Never reached.");
        }
        return Scrollbar(
            thickness: width / 25,
            radius: const Radius.circular(12),
            controller: controller,
            interactive: true,
            child: child);
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    controller?.dispose();
  }
}
