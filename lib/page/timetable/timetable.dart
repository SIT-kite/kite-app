import 'package:flutter/material.dart';
import 'package:kite/page/timetable/bottom_sheet.dart';
import 'package:kite/entity/edu/timetable.dart';
import 'package:kite/page/timetable/daily_timetable.dart';

class TimetablePage extends StatefulWidget {
  const TimetablePage({Key? key}) : super(key: key);

  @override
  _TimetablePageState createState() => _TimetablePageState();
}

class _TimetablePageState extends State<TimetablePage> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 30.0,
        title: const Text("课程表"),
        actions: <Widget>[
          _MorePopupMenuButton(context),
        ],
      ),
      body: const DailyTimetable(),
    );
  }

  // ignore: non_constant_identifier_names
  PopupMenuButton _MorePopupMenuButton(BuildContext context) {
    return PopupMenuButton<Function>(
      itemBuilder: (BuildContext context) {
        return <PopupMenuEntry<Function>>[
          PopupMenuItem<Function>(
            child: const Text("刷新"),
            value: _RefreshClassSchedule,
          ),
          PopupMenuItem<Function>(
            child: const Text("导出课表"),
            value: _DeriveClassSchedule,
          ),
          PopupMenuItem<Function>(
            child: const Text("导入课表"),
            value: _LoadClassSchedule,
          ),
        ];
      },
      onSelected: (Function fun) {
        fun();
      },
    );
  }

  // ignore: non_constant_identifier_names
  bool _RefreshClassSchedule() {
    print("refresh");
    return true;
  }

  // ignore: non_constant_identifier_names
  bool _LoadClassSchedule() {
    print("load class schedule");
    return true;
  }

  // ignore: non_constant_identifier_names
  bool _DeriveClassSchedule() {
    print("derive class schedule");
    return true;
  }

}



