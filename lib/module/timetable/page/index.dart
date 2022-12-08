import 'package:flutter/widgets.dart';

import '../entity/meta.dart';
import '../events.dart';
import '../init.dart';
import 'mine.dart';
import 'timetable.dart';

class TimetableIndexPage extends StatefulWidget {
  const TimetableIndexPage({super.key});

  @override
  State<TimetableIndexPage> createState() => _TimetableIndexPageState();
}

class _TimetableIndexPageState extends State<TimetableIndexPage> {
  final storage = TimetableInit.timetableStorage;

// 课表元数据
  TimetableMeta? _selected;

  @override
  void initState() {
    super.initState();
    refresh();
    eventBus.on<CurrentTimetableChangeEvent>().listen((event) {
      refresh();
    });
  }

  void refresh() {
    if (!mounted) return;
    setState(() {
      _selected = storage.currentTableMeta;
    });
  }

  @override
  Widget build(BuildContext context) {
    final selected = _selected;
    if (selected == null) {
      return const MyTimetablePage();
    } else {
      return TimetablePage(
        selected: selected,
      );
    }
  }
}
