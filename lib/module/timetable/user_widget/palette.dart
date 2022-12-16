import 'package:flutter/widgets.dart';

import '../events.dart';
import '../init.dart';
import '../using.dart';

class TimetableStyle extends InheritedWidget {
  final List<ColorPair> colors;
  final bool useNewUI;

  const TimetableStyle({
    super.key,
    required this.colors,
    required this.useNewUI,
    required super.child,
  });

  static TimetableStyle of(BuildContext context) {
    final TimetableStyle? result = context.dependOnInheritedWidgetOfExactType<TimetableStyle>();
    assert(result != null, 'No TimetablePalette found in context');
    return result!;
  }

  @override
  bool updateShouldNotify(TimetableStyle oldWidget) {
    return colors != oldWidget.colors || useNewUI != oldWidget.useNewUI;
  }
}

class TimetableStyleProv extends StatefulWidget {
  final Widget child;

  const TimetableStyleProv({super.key, required this.child});

  @override
  TimetableStyleProvState createState() => TimetableStyleProvState();
}

class TimetableStyleProvState extends State<TimetableStyleProv> {
  final storage = TimetableInit.timetableStorage;

  @override
  void initState() {
    super.initState();
    eventBus.on<TimetableStyleChangeEvent>().listen((event) {
      if (!mounted) return;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return TimetableStyle(
      colors: storage.useOldSchoolColors == true ? CourseColor.oldSchool : CourseColor.v1_5,
      useNewUI: storage.useNewUI ?? false,
      child: widget.child,
    );
  }
}
