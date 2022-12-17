import 'package:flutter/material.dart';
import 'package:kite/entities.dart';
import 'package:rettulf/rettulf.dart';
import '../../using.dart';

class DailyTimeline extends StatefulWidget {
  final List<SitCourse> courseKey2Entity;
  final SitTimetableDay day;

  const DailyTimeline({
    super.key,
    required this.courseKey2Entity,
    required this.day,
  });

  @override
  State<DailyTimeline> createState() => _DailyTimelineState();
}

class _DailyTimelineState extends State<DailyTimeline> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(itemCount: widget.day.timeslots2Lessons.length, itemBuilder: buildRow);
  }

  Widget buildRow(BuildContext context, int timeslot) {
    final lessons = widget.day.timeslots2Lessons[timeslot];
    //getBuildingTimetable()
    return [
      SizedBox(),
    ].stack();
  }
  /*Widget buildTime(){

  }*/
}

