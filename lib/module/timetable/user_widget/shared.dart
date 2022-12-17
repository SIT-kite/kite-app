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
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rettulf/rettulf.dart';
import '../entity/entity.dart';
import '../using.dart';

Widget buildButton(BuildContext ctx, String text, {VoidCallback? onPressed}) {
  return ElevatedButton(
    onPressed: onPressed,
    child: Padding(
      padding: const EdgeInsets.all(12),
      child: Text(
        text,
        style: ctx.textTheme.titleLarge,
      ),
    ),
  );
}

extension Wrapper on Widget {
  Widget vwrap() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: this,
    );
  }
}

Widget buildInfo(BuildContext ctx, SitCourse course) {
  return AutoSizeText.rich(
    TextSpan(children: [
      TextSpan(
        text: stylizeCourseName(course.courseName),
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12.sp),
      ),
      TextSpan(
        text: "\n${formatPlace(course.place)}\n${course.teachers.join(',')}",
        style: TextStyle(color: ctx.textColor.withOpacity(0.65), fontSize: 12.sp),
      ),
    ]),
    minFontSize: 0,
    stepGranularity: 0.1,
    maxLines: ctx.isPortrait ? 6 : 5,
    textAlign: TextAlign.center,
  );
}
