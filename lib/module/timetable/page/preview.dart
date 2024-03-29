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

import '../cache.dart';
import '../entity/course.dart';
import '../entity/meta.dart';
import '../user_widget/timetable.dart';
import '../using.dart';

///
/// There is no need to persist a preview after activity destroyed.
class TimetablePreviewPage extends StatelessWidget {
  final TimetableMeta meta;
  final List<Course> courses;

  const TimetablePreviewPage({
    super.key,
    required this.meta,
    required this.courses,
  });

  @override
  Widget build(BuildContext context) {
    final ValueNotifier<TimetablePosition> $currentPos = ValueNotifier(
      TimetablePosition.locate(meta.startDate, DateTime.now()),
    );
    final ValueNotifier<DisplayMode> $displayMode = ValueNotifier(DisplayMode.weekly);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${i18n.timetablePreviewTitle} ${meta.name}',
          overflow: TextOverflow.ellipsis,
        ),
      ),
      body: TimetableViewer(
        $currentPos: $currentPos,
        initialTableMeta: meta,
        initialTableCourses: courses,
        tableCache: TableCache(),
        $displayMode: $displayMode,
      ),
    );
  }
}
