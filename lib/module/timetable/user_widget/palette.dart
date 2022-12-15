import 'package:flutter/widgets.dart';

import '../events.dart';
import '../init.dart';
import '../using.dart';

class TimetablePalette extends InheritedWidget {
  final List<ColorPair> colors;

  const TimetablePalette({
    super.key,
    required this.colors,
    required super.child,
  });

  static TimetablePalette of(BuildContext context) {
    final TimetablePalette? result = context.dependOnInheritedWidgetOfExactType<TimetablePalette>();
    assert(result != null, 'No TimetablePalette found in context');
    return result!;
  }

  @override
  bool updateShouldNotify(TimetablePalette oldWidget) {
    return colors != oldWidget.colors;
  }
}

class TimetablePaletteProv extends StatefulWidget {
  final Widget child;

  const TimetablePaletteProv({super.key, required this.child});

  @override
  TimetablePaletteProvState createState() => TimetablePaletteProvState();
}

class TimetablePaletteProvState extends State<TimetablePaletteProv> {
  final storage = TimetableInit.timetableStorage;

  @override
  void initState() {
    super.initState();
    eventBus.on<TimetablePaletteChangeEvent>().listen((event) {
      if (!mounted) return;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return TimetablePalette(
      colors: storage.useOldSchoolColors == true ? CourseColor.oldSchool : CourseColor.v1_5,
      child: widget.child,
    );
  }
}
