import 'package:flutter/material.dart';
import 'package:kite/design/colors.dart';
import 'package:rettulf/rettulf.dart';
import 'package:universal_platform/universal_platform.dart';

extension ScrollWidgetListEx on List<Widget> {
  Widget scrolledWithBar({Key? key, ScrollController? controller}) {
    return _KiteScrolledWithBar(
      key: key,
      controller: controller,
      children: this,
    );
  }
}

extension ScrollSingleWidgetEx on Widget {
  Widget scrolledWithBar({Key? key, ScrollController? controller}) {
    return _KiteScrolledWithBar(
      key: key,
      controller: controller,
      child: this,
    );
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
    controller = widget.controller ?? ScrollController();
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
            child = child.scrolled(
                controller: controller,
                physics: UniversalPlatform.isDesktop ? const NeverScrollableScrollPhysics() : null);
          } else {
            assert(child.controller == controller, "The ScrollView external provided should have no controller.");
            if (UniversalPlatform.isDesktop) {
              assert(child.physics is NeverScrollableScrollPhysics,
                  "A ScrollView shouldn't have any scroll physics on desktop.");
            }
          }
        } else if (children != null) {
          // list mode
          child = children.listview(
              controller: controller,
              physics: UniversalPlatform.isDesktop ? const NeverScrollableScrollPhysics() : null);
        } else {
          throw Exception("Never reached.");
        }
        return RawScrollbar(
            thickness: UniversalPlatform.isDesktop ? width / 30 : width / 20,
            radius: const Radius.circular(12),
            thumbColor: context.themeColor.withOpacity(0.8),
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
