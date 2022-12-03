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
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rettulf/rettulf.dart';

class LeavingBlank extends StatelessWidget {
  final IconData icon;
  final String desc;
  final VoidCallback? onIconTap;

  const LeavingBlank({super.key, required this.icon, required this.desc, this.onIconTap});

  @override
  Widget build(BuildContext context) {
    Widget iconWidget = icon.make(size: 120).padAll(20);
    if (onIconTap != null) {
      iconWidget = iconWidget.on(tap: onIconTap);
    }
    return [
      iconWidget.expanded(),
      desc
          .text(
            style: context.textTheme.titleLarge,
          )
          .center()
          .padAll(10)
          .expanded(),
    ].column(maa: MAAlign.spaceAround).center();
  }
}
