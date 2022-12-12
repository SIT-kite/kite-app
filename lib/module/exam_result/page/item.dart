/*
 * 上应小风筝  便利校园，一步到位
 * Copyright (C) 2022 上海应用技术大学 上应小风筝团队
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */
import 'package:flutter/material.dart';
import 'package:kite/route.dart';
import 'package:msh_checkbox/msh_checkbox.dart';
import 'package:rettulf/rettulf.dart';

import '../entity/result.dart';
import '../init.dart';
import '../using.dart';
import 'index.dart';

class ScoreItem extends StatefulWidget {
  final ExamResult result;
  final int index;
  final bool isSelectingMode;

  const ScoreItem(this.result, {super.key, required this.index, required this.isSelectingMode});

  @override
  State<ScoreItem> createState() => _ScoreItemState();
}

class _ScoreItemState extends State<ScoreItem> {
  late ExamResult _score;
  final size = 45.0;

  @override
  Widget build(BuildContext context) {
    _score = widget.result;
    final titleStyle = Theme.of(context).textTheme.titleMedium;
    final subtitleStyle = Theme.of(context).textTheme.bodyMedium;
    final scoreStyle = titleStyle?.copyWith(color: context.darkSafeThemeColor);
    final controller = MultiselectScope.controllerOf(context);
    final itemIsSelected = controller.isSelected(widget.index);
    final selecting = widget.isSelectingMode;
    Widget buildLeading() {
      if (selecting) {
        return MSHCheckbox(
          size: 30,
          duration: const Duration(milliseconds: 300),
          value: itemIsSelected,
          colorConfig: MSHColorConfig.fromCheckedUncheckedDisabled(
            checkedColor: Colors.blue,
          ),
          style: MSHCheckboxStyle.stroke,
          onChanged: (selected) {
            setState(() {
              controller.select(widget.index);
            });
          },
        ).sized(key: const ValueKey("Checkbox"), width: size, height: size);
      } else {
        return Image.asset(
          'assets/course/${CourseCategory.query(_score.course)}.png',
        ).sized(key: const ValueKey("Icon"), width: size, height: size);
      }
    }

    Widget buildTrailing() {
      if (!_score.value.isNaN) {
        return Text(_score.value.toString(), style: scoreStyle);
      }
      return Text('待评教', style: scoreStyle);
    }

    return ListTile(
        leading: buildLeading().animatedSwitched(
          d: const Duration(milliseconds: 300),
        ),
        title: Text(_score.course, style: titleStyle),
        subtitle: Text('${_score.courseId[0] != 'G' ? '必修' : '选修'} | 学分: ${_score.credit}', style: subtitleStyle),
        trailing: buildTrailing());
  }

  Widget _buildScoreDetailView(List<ExamResultDetail> scoreDetails) {
    return Container(
      alignment: Alignment.centerLeft,
      decoration: const BoxDecoration(
        border: Border(
          left: BorderSide(color: Colors.blue, width: 3),
        ),
      ),
      child: Column(
        children: scoreDetails.map((e) => Text('${e.scoreType} (${e.percentage}): ${e.value}')).toList(),
      ),
    );
  }

  Widget _buildScoreDetail() {
    final future =
        ExamResultInit.resultService.getResultDetail(_score.innerClassId, _score.schoolYear, _score.semester);

    return FutureBuilder(
      future: future,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          return _buildScoreDetailView(snapshot.data!);
        } else if (snapshot.hasError) {
          return Text('${i18n.failed}: ${snapshot.error.runtimeType}');
        }
        return Placeholders.loading();
      },
    );
  }
}
