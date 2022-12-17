import 'package:flutter/material.dart';
import 'package:kite/entities.dart';
import 'package:rettulf/rettulf.dart';

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
    return Container();
  }

  Widget buildRow(BuildContext context, int timeslot){
    return [
      SizedBox()
    ].stack();
  }
}
