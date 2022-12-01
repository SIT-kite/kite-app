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

import 'dart:collection';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:kite/global/hive_type_id_pool.dart';
import 'package:kite/l10n/extension.dart';
import 'package:kite/util/user.dart';

part 'home.g.dart';

// TODO: Rename
@HiveType(typeId: HiveTypeIdPool.ftypeItem)
enum FType {
  /// 升级
  @HiveField(0)
  upgrade,

  /// 公告
  @HiveField(1)
  kiteBulletin,

  /// 课程表
  @HiveField(2)
  timetable,

  /// 体温上报
  @HiveField(3)
  reportTemp,

  /// 考试安排
  @HiveField(4)
  examArr,

  /// 空教室
  @HiveField(5)
  classroomBrowser,

  /// 活动
  @HiveField(6)
  activity,

  /// 消费查询
  @HiveField(7)
  expense,

  /// 成绩查询
  @HiveField(8)
  examResult,

  /// 图书馆
  @HiveField(9)
  library,

  /// 办公
  @HiveField(10)
  application,

  /// Edu 邮箱
  @HiveField(11)
  eduEmail,

  /// OA 公告
  @HiveField(12)
  oaAnnouncement,

  /// 常用电话
  @HiveField(13)
  yellowPages,

  /// 小游戏
  @HiveField(14)
  game,

  /// wiki
  @HiveField(15)
  wiki,

  /// 分隔符
  @HiveField(16)
  separator,

  /// 上应互助
  @HiveField(17)
  bbs,

  /// 扫码
  @HiveField(18)
  scanner,

  /// 迎新(入学信息)
  @HiveField(19)
  freshman,

  /// 切换账户
  @HiveField(20)
  switchAccount,

  /// 风筝时刻
  @HiveField(21)
  kiteBoard,

  /// 电费查询
  @HiveField(22)
  electricityBill;

  String localized() {
    switch (this) {
      case FType.upgrade:
        return i18n.ftype_upgrade;
      case FType.kiteBulletin:
        return i18n.ftype_kiteBulletin;
      case FType.timetable:
        return i18n.ftype_timetable;
      case FType.reportTemp:
        return i18n.ftype_reportTemp;
      case FType.examArr:
        return i18n.ftype_examArr;
      case FType.classroomBrowser:
        return i18n.ftype_classroomBrowser;
      case FType.activity:
        return i18n.ftype_activity;
      case FType.expense:
        return i18n.ftype_expense;
      case FType.examResult:
        return i18n.ftype_examResult;
      case FType.library:
        return i18n.ftype_library;
      case FType.application:
        return i18n.ftype_application;
      case FType.eduEmail:
        return i18n.ftype_eduEmail;
      case FType.oaAnnouncement:
        return i18n.ftype_oaAnnouncement;
      case FType.yellowPages:
        return i18n.ftype_yellowPages;
      case FType.game:
        return i18n.ftype_game;
      case FType.wiki:
        return i18n.ftype_wiki;
      case FType.separator:
        return i18n.ftype_separator;
      case FType.bbs:
        return i18n.ftype_bbs;
      case FType.scanner:
        return i18n.ftype_scanner;
      case FType.freshman:
        return i18n.ftype_freshman;
      case FType.switchAccount:
        return i18n.ftype_switchAccount;
      case FType.kiteBoard:
        return i18n.ftype_kiteBoard;
      case FType.electricityBill:
        return i18n.ftype_elecBill;
    }
  }

  String localizedDesc() {
    switch (this) {
      case FType.upgrade:
        return i18n.ftype_upgrade_desc;
      case FType.kiteBulletin:
        return i18n.ftype_kiteBulletin_desc;
      case FType.timetable:
        return i18n.ftype_timetable_desc;
      case FType.reportTemp:
        return i18n.ftype_reportTemp_desc;
      case FType.examArr:
        return i18n.ftype_examArr_desc;
      case FType.classroomBrowser:
        return i18n.ftype_classroomBrowser_desc;
      case FType.activity:
        return i18n.ftype_activity_desc;
      case FType.expense:
        return i18n.ftype_expense_desc;
      case FType.examResult:
        return i18n.ftype_examResult_desc;
      case FType.library:
        return i18n.ftype_library_desc;
      case FType.application:
        return i18n.ftype_application_desc;
      case FType.eduEmail:
        return i18n.ftype_eduEmail_desc;
      case FType.oaAnnouncement:
        return i18n.ftype_oaAnnouncement_desc;
      case FType.yellowPages:
        return i18n.ftype_yellowPages_desc;
      case FType.game:
        return i18n.ftype_game_desc;
      case FType.wiki:
        return i18n.ftype_wiki_desc;
      case FType.separator:
        return i18n.ftype_separator_desc;
      case FType.bbs:
        return i18n.ftype_bbs_desc;
      case FType.scanner:
        return i18n.ftype_scanner_desc;
      case FType.freshman:
        return i18n.ftype_freshman_desc;
      case FType.switchAccount:
        return i18n.ftype_switchAccount_desc;
      case FType.kiteBoard:
        return i18n.ftype_kiteBoard_desc;
      case FType.electricityBill:
        return i18n.ftype_elecBill_desc;
    }
  }
}

/// 用户的功能列表
abstract class IUserBricks {
  List<FType> make();
}

/// 本、专科生默认功能列表
class UndergraduateBricks implements IUserBricks {
  @override
  List<FType> make() {
    return <FType>[
      FType.upgrade,
      FType.kiteBulletin,
      FType.timetable,
      FType.reportTemp,
      FType.separator,
      FType.examArr,
      FType.classroomBrowser,
      FType.activity,
      FType.expense,
      FType.electricityBill,
      FType.examResult,
      FType.library,
      FType.application,
      FType.eduEmail,
      FType.oaAnnouncement,
      FType.separator,
      FType.freshman,
      FType.scanner,
      FType.bbs,
      FType.yellowPages,
      FType.game,
      FType.kiteBoard,
      FType.wiki,
      FType.separator,
    ];
  }
}

/// 研究生默认功能列表
class PostgraduateBricks implements IUserBricks {
  @override
  List<FType> make() {
    return <FType>[
      FType.upgrade,
      FType.kiteBulletin,
      FType.reportTemp,
      FType.separator,
      FType.classroomBrowser,
      FType.expense,
      FType.electricityBill,
      FType.library,
      FType.application,
      FType.eduEmail,
      FType.oaAnnouncement,
      FType.separator,
      FType.freshman,
      FType.scanner,
      FType.bbs,
      FType.yellowPages,
      FType.game,
      FType.kiteBoard,
      FType.wiki,
      FType.separator,
    ];
  }
}

/// 教师账户默认功能列表
class TeacherBricks implements IUserBricks {
  @override
  List<FType> make() {
    return <FType>[
      FType.upgrade,
      FType.kiteBulletin,
      FType.reportTemp,
      FType.separator,
      FType.expense,
      FType.electricityBill,
      FType.library,
      FType.application,
      FType.eduEmail,
      FType.oaAnnouncement,
      FType.separator,
      FType.scanner,
      FType.bbs,
      FType.yellowPages,
      FType.game,
      FType.kiteBoard,
      FType.wiki,
      FType.separator,
    ];
  }
}

/// 新生功能列表
class FreshmanBricks implements IUserBricks {
  @override
  List<FType> make() {
    return <FType>[
      FType.upgrade,
      FType.kiteBulletin,
      FType.switchAccount,
      FType.separator,
      FType.freshman,
      FType.scanner,
      FType.bbs,
      FType.yellowPages,
      FType.kiteBoard,
      FType.wiki,
      FType.separator,
    ];
  }
}

class UserBricksFactory {
  static final _cache = HashMap<UserType, IUserBricks>();

  static IUserBricks create({required UserType by}) {
    if (_cache.containsKey(by)) {
      return _cache[by]!;
    }
    _cache[by] = {
      UserType.undergraduate: () => UndergraduateBricks(),
      UserType.postgraduate: () => PostgraduateBricks(),
      UserType.teacher: () => TeacherBricks(),
      UserType.freshman: () => FreshmanBricks(),
    }[by]!();

    return _cache[by]!;
  }
}

List<FType> makeDefaultBricks(UserType? userType) {
  return UserBricksFactory.create(by: userType ?? UserType.freshman).make();
}
