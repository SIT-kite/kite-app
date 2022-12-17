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
import 'package:msh_checkbox/msh_checkbox.dart';
import 'package:rettulf/rettulf.dart';

import '../entity/result.dart';
import '../init.dart';
import '../using.dart';

class ScoreItem extends StatefulWidget {
  final ExamResult result;
  final int index;
  final bool isSelectingMode;

  const ScoreItem(this.result, {super.key, required this.index, required this.isSelectingMode});

  @override
  State<ScoreItem> createState() => _ScoreItemState();
}

class _ScoreItemState extends State<ScoreItem> {
  ExamResult get result => widget.result;
  static const iconSize = 45.0;
  List<ExamResultDetail>? details;

  @override
  void initState() {
    super.initState();
    ExamResultInit.resultService.getResultDetail(result.innerClassId, result.schoolYear, result.semester).then((value) {
      if (details != value) {
        if (!mounted) return;
        setState(() {
          details = value;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
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
        ).sized(key: const ValueKey("Checkbox"), width: iconSize, height: iconSize);
      } else {
        return Image.asset(
          CourseCategory.iconPathOf(courseName: result.course),
        ).sized(key: const ValueKey("Icon"), width: iconSize, height: iconSize);
      }
    }

    Widget buildTrailing() {
      // The value of exam result is NaN means this lesson requires evaluation.
      if (result.value.isNaN) {
        return i18n.lessonNotEvaluated.text(style: scoreStyle);
      } else {
        return Text(result.value.toString(), style: scoreStyle);
      }
    }

    final tile = ListTile(
      leading: buildLeading().animatedSwitched(
        d: const Duration(milliseconds: 300),
      ),
      title: Text(stylizeCourseName(result.course), style: titleStyle),
      subtitle: getSubtitle().text(style: subtitleStyle),
      trailing: buildTrailing(),
    );
    return tile;
  }

  String getSubtitle() {
    final courseType = result.courseId[0] != 'G' ? i18n.courseCompulsory : i18n.courseElective;
    return '$courseType | ${i18n.courseCredit}: ${result.credit}';
  }

  // TODO: Where to display this?
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
}
