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
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kite/feature/home/page/item/bbs.dart';
import 'package:kite/feature/home/page/item/freshman.dart';
import 'package:kite/feature/home/page/item/scan.dart';
import 'package:kite/feature/home/page/item/switch.dart';

import '../../entity/home.dart';
import 'bulletin.dart';
import 'classroom.dart';
import 'contact.dart';
import 'event.dart';
import 'exam.dart';
import 'expense.dart';
import 'game.dart';
import 'library.dart';
import 'mail.dart';
import 'notice.dart';
import 'office.dart';
import 'report.dart';
import 'score.dart';
import 'timetable.dart';
import 'upgrade.dart';
import 'wiki.dart';

export 'bbs.dart';
export 'bulletin.dart';
export 'classroom.dart';
export 'contact.dart';
export 'electricity.dart';
export 'event.dart';
export 'exam.dart';
export 'expense.dart';
export 'game.dart';
export 'library.dart';
export 'mail.dart';
export 'night.dart';
export 'notice.dart';
export 'office.dart';
export 'report.dart';
export 'report.dart';
export 'score.dart';
export 'timetable.dart';
export 'timetable.dart';
export 'upgrade.dart';
export 'wiki.dart';

class HomeFunctionButton extends StatelessWidget {
  final String? route;
  final String? icon;
  final Widget? iconWidget;
  final String title;
  final String? subtitle;
  final VoidCallback? onPressed;
  HomeFunctionButton({
    this.route,
    this.onPressed,
    required this.title,
    this.subtitle,
    this.icon,
    this.iconWidget,
    Key? key,
  }) : super(key: key) {
    assert(icon != null || iconWidget != null);
  }

  @override
  Widget build(BuildContext context) {
    final titleStyle = Theme.of(context).textTheme.headline4?.copyWith(color: Colors.black54);
    final subtitleStyle = Theme.of(context).textTheme.bodyText2?.copyWith(color: Colors.black54);

    return Container(
      decoration: BoxDecoration(color: Colors.white.withOpacity(0.6)),
      child: ListTile(
        leading:
            iconWidget ?? SvgPicture.asset(icon!, height: 30.h, width: 30.w, color: Theme.of(context).primaryColor),
        title: Text(title, style: titleStyle),
        subtitle: Text(subtitle ?? '', style: subtitleStyle, maxLines: 1, overflow: TextOverflow.ellipsis),
        // dense: true,
        onTap: () {
          if (onPressed != null) {
            onPressed!();
            return;
          }
          if (route != null) {
            Navigator.of(context).pushNamed(route!);
          }
        },
        style: ListTileStyle.list,
      ),
    );
  }
}

class FunctionButtonFactory {
  static Widget createFunctionButton(FunctionType type) {
    switch (type) {
      case FunctionType.upgrade:
        return const UpgradeItem();
      case FunctionType.notice:
        return const NoticeItem();
      case FunctionType.timetable:
        return const TimetableItem();
      case FunctionType.report:
        return const ReportItem();
      case FunctionType.exam:
        return const ExamItem();
      case FunctionType.classroom:
        return const ClassroomItem();
      case FunctionType.event:
        return const EventItem();
      case FunctionType.expense:
        return const ExpenseItem();
      case FunctionType.score:
        return const ScoreItem();
      case FunctionType.library:
        return const LibraryItem();
      case FunctionType.office:
        return const OfficeItem();
      case FunctionType.mail:
        return const MailItem();
      case FunctionType.bulletin:
        return const BulletinItem();
      case FunctionType.contact:
        return const ContactItem();
      case FunctionType.game:
        return const GameItem();
      case FunctionType.wiki:
        return const WikiItem();
      case FunctionType.separator:
        return Container();
      case FunctionType.bbs:
        return const BbsItem();
      case FunctionType.scanner:
        return const ScanItem();
      case FunctionType.freshman:
        return const FreshmanItem();
      case FunctionType.switchAccount:
        return const SwitchAccountItem();
    }
  }
}
