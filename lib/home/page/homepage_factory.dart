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
import 'package:universal_platform/universal_platform.dart';

import '../../launcher.dart';
import '../../route.dart';
import '../../util/logger.dart';
import '../../util/scanner.dart';
import '../entity/home.dart';

import 'brick.dart';
import 'magic_brick/electricity.dart';
import 'magic_brick/upgrade.dart';
import 'magic_brick/exam.dart';
import 'magic_brick/expense.dart';
import 'magic_brick/freshman.dart';
import 'magic_brick/library.dart';
import 'magic_brick/mail.dart';
import 'magic_brick/bulletin.dart';
import 'magic_brick/application.dart';
import 'magic_brick/report.dart';

class HomepageFactory {
  static final Map<FType, WidgetBuilder?> builders = {
    FType.upgrade: (context) => const UpgradeItem(),
    FType.kiteBulletin: (context) => const KiteBulletinItem(),
    FType.timetable: (context) => Brick(
          route: RouteTable.timetable,
          icon: SvgAssetIcon('assets/home/icon_timetable.svg'),
          title: FType.timetable.localized(),
          subtitle: FType.timetable.localizedDesc(),
        ),
    FType.reportTemp: (context) => const ReportTempItem(),
    FType.examArr: (context) => const ExamArrangementItem(),
    FType.classroomBrowser: (context) => Brick(
          route: RouteTable.classroomBrowser,
          icon: SvgAssetIcon('assets/home/icon_classroom.svg'),
          title: FType.classroomBrowser.localized(),
          subtitle: FType.classroomBrowser.localizedDesc(),
        ),
    FType.activity: (context) => Brick(
          route: RouteTable.activity,
          icon: SvgAssetIcon('assets/home/icon_event.svg'),
          title: FType.activity.localized(),
          subtitle: FType.activity.localizedDesc(),
        ),
    FType.expense: (context) => const ExpenseItem(),
    FType.examResult: (context) => Brick(
          route: RouteTable.examResult,
          icon: SvgAssetIcon('assets/home/icon_score.svg'),
          title: FType.examResult.localized(),
          subtitle: FType.examResult.localizedDesc(),
        ),
    FType.library: (context) => const LibraryItem(),
    FType.application: (context) => const ApplicationItem(),
    FType.eduEmail: (context) => const EduEmailItem(),
    FType.oaAnnouncement: (context) => Brick(
          route: RouteTable.oaAnnouncement,
          icon: SvgAssetIcon('assets/home/icon_bulletin.svg'),
          title: FType.oaAnnouncement.localized(),
          subtitle: FType.oaAnnouncement.localizedDesc(),
        ),
    FType.yellowPages: (context) => Brick(
          route: RouteTable.yellowPages,
          icon: SvgAssetIcon('assets/home/icon_contact.svg'),
          title: FType.yellowPages.localized(),
          subtitle: FType.yellowPages.localizedDesc(),
        ),
    FType.game: (context) => Brick(
          route: RouteTable.game,
          icon: SvgAssetIcon('assets/home/icon_game.svg'),
          title: FType.game.localized(),
          subtitle: FType.game.localizedDesc(),
        ),
    FType.wiki: (context) => Brick(
          route: RouteTable.wiki,
          icon: SvgAssetIcon('assets/home/icon_wiki.svg'),
          title: FType.wiki.localized(),
          subtitle: FType.wiki.localizedDesc(),
        ),
    FType.separator: (context) => Container(),
    FType.bbs: UniversalPlatform.isDesktopOrWeb
        ? null
        : (context) => Brick(
              route: RouteTable.bbs,
              icon: SvgAssetIcon('assets/home/icon_bbs.svg'),
              title: FType.bbs.localized(),
              subtitle: FType.bbs.localizedDesc(),
            ),
    FType.scanner: UniversalPlatform.isDesktopOrWeb
        ? null
        : (context) => Brick(
              onPressed: () async {
                final result = await scan(context);
                Log.info('扫码结果: $result');
                if (result != null) GlobalLauncher.launch(result);
              },
              icon: SysIcon(Icons.qr_code_scanner),
              title: FType.scanner.localized(),
              subtitle: FType.scanner.localizedDesc(),
            ),
    FType.freshman: (context) => const FreshmanItem(),
    FType.switchAccount: (context) => Brick(
          route: RouteTable.login,
          routeArgs: const {"disableOffline": true},
          icon: (size, color) => Icon(Icons.switch_account, size: size, color: color),
          title: FType.switchAccount.localized(),
          subtitle: FType.switchAccount.localizedDesc(),
        ),
    FType.electricityBill: (context) => const ElectricityBillItem(),
    FType.kiteBoard: (context) => Brick(
          route: RouteTable.kiteBoard,
          icon: SvgAssetIcon('assets/home/icon_board.svg'),
          title: FType.kiteBoard.localized(),
          subtitle: FType.kiteBoard.localizedDesc(),
        ),
  };

  static Widget? buildBrickWidget(BuildContext context, FType type) {
    if (!builders.containsKey(type)) {
      throw UnimplementedError("Brick[${type.name}] is not available.");
    }
    final builder = builders[type];
    return builder?.call(context);
  }
}
