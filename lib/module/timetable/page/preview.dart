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

import '../entity/course.dart';
import '../entity/entity.dart';
import '../entity/meta.dart';
import '../user_widget/style.dart';
import '../user_widget/interface.dart';
import '../using.dart';
import '../user_widget/new_ui/timetable.dart' as new_ui;
import '../user_widget/classic_ui/timetable.dart' as classic_ui;

///
/// There is no need to persist a preview after activity destroyed.
class TimetablePreviewPage extends StatefulWidget {
  final SitTimetable timetable;

  const TimetablePreviewPage({super.key, required this.timetable});

  @override
  State<StatefulWidget> createState() => _TimetablePreviewPageState();
}

class _TimetablePreviewPageState extends State<TimetablePreviewPage> {
  final ValueNotifier<DisplayMode> $displayMode = ValueNotifier(DisplayMode.weekly);
  late final ValueNotifier<TimetablePosition> $currentPos = ValueNotifier(
    TimetablePosition.locate(widget.timetable.startDate, DateTime.now()),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            '${i18n.timetablePreviewTitle} ${widget.timetable.name}',
            overflow: TextOverflow.ellipsis,
          ),
        ),
        body: TimetableStyleProv(
          child: new_ui.TimetableViewer(
            timetable: widget.timetable,
            $currentPos: $currentPos,
            $displayMode: $displayMode,
          ),
        ));
  }
}
