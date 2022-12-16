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

import '../entity/entity.dart';
import '../entity/meta.dart';
import '../events.dart';
import '../init.dart';
import '../user_widget/palette.dart';
import 'mine.dart';
import 'timetable.dart';

class TimetableIndexPage extends StatefulWidget {
  const TimetableIndexPage({super.key});

  @override
  State<TimetableIndexPage> createState() => _TimetableIndexPageState();
}

class _TimetableIndexPageState extends State<TimetableIndexPage> {
  final storage = TimetableInit.timetableStorage;

  SitTimetable? _selected;

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
    final currentId = storage.currentTimetableId;
    if (currentId != null) {
      setState(() {
        _selected = storage.getSitTimetableBy(id: currentId);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final selected = _selected;
    if (selected == null) {
      // If no timetable selected, navigate to Mine page to select/import one.
      return const MyTimetablePage();
    } else {
      return TimetableStyleProv(
        child: TimetablePage(
          timetable: selected,
        ),
      );
    }
  }
}
