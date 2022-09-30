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
@HiveType(typeId: HiveTypeIdPool.functionTypeItem)
enum FunctionType {
  /// 升级
  @HiveField(0)
  upgrade,

  /// 公告
  @HiveField(1)
  notice,

  /// 课程表
  @HiveField(2)
  timetable,

  /// 体温上报
  @HiveField(3)
  report,

  /// 考试安排
  @HiveField(4)
  exam,

  /// 空教室
  @HiveField(5)
  classroom,

  /// 活动
  @HiveField(6)
  event,

  /// 消费查询
  @HiveField(7)
  expense,

  /// 成绩查询
  @HiveField(8)
  score,

  /// 图书馆
  @HiveField(9)
  library,

  /// 办公
  @HiveField(10)
  office,

  /// Edu 邮箱
  @HiveField(11)
  mail,

  /// OA 公告
  @HiveField(12)
  bulletin,

  /// 常用电话
  @HiveField(13)
  contact,

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
  board,

  /// 电费查询
  @HiveField(22)
  electricity;

  String localized() {
    switch (this) {
      case FunctionType.upgrade:
        return i18n.ftype_upgrade;
      case FunctionType.notice:
        return i18n.ftype_kiteBulletin;
      case FunctionType.timetable:
        return i18n.ftype_timetable;
      case FunctionType.report:
        return i18n.ftype_reportTemp;
      case FunctionType.exam:
        return i18n.ftype_examArr;
      case FunctionType.classroom:
        return i18n.ftype_classroomBrowser;
      case FunctionType.event:
        return i18n.ftype_activity;
      case FunctionType.expense:
        return i18n.ftype_expense;
      case FunctionType.score:
        return i18n.ftype_examResult;
      case FunctionType.library:
        return i18n.ftype_library;
      case FunctionType.office:
        return i18n.ftype_application;
      case FunctionType.mail:
        return i18n.ftype_eduEmail;
      case FunctionType.bulletin:
        return i18n.ftype_oaAnnouncement;
      case FunctionType.contact:
        return i18n.ftype_yellowPages;
      case FunctionType.game:
        return i18n.ftype_game;
      case FunctionType.wiki:
        return i18n.ftype_wiki;
      case FunctionType.separator:
        return i18n.ftype_separator;
      case FunctionType.bbs:
        return i18n.ftype_bbs;
      case FunctionType.scanner:
        return i18n.ftype_scanner;
      case FunctionType.freshman:
        return i18n.ftype_freshman;
      case FunctionType.switchAccount:
        return i18n.ftype_switchAccount;
      case FunctionType.board:
        return i18n.ftype_kiteBoard;
      case FunctionType.electricity:
        return i18n.ftype_elecBill;
    }
  }

  String localizedDesc() {
    switch (this) {
      case FunctionType.upgrade:
        return i18n.ftype_upgrade_desc;
      case FunctionType.notice:
        return i18n.ftype_kiteBulletin_desc;
      case FunctionType.timetable:
        return i18n.ftype_timetable_desc;
      case FunctionType.report:
        return i18n.ftype_reportTemp_desc;
      case FunctionType.exam:
        return i18n.ftype_examArr_desc;
      case FunctionType.classroom:
        return i18n.ftype_classroomBrowser_desc;
      case FunctionType.event:
        return i18n.ftype_activity_desc;
      case FunctionType.expense:
        return i18n.ftype_expense_desc;
      case FunctionType.score:
        return i18n.ftype_examResult_desc;
      case FunctionType.library:
        return i18n.ftype_library_desc;
      case FunctionType.office:
        return i18n.ftype_application_desc;
      case FunctionType.mail:
        return i18n.ftype_eduEmail_desc;
      case FunctionType.bulletin:
        return i18n.ftype_oaAnnouncement_desc;
      case FunctionType.contact:
        return i18n.ftype_yellowPages_desc;
      case FunctionType.game:
        return i18n.ftype_game_desc;
      case FunctionType.wiki:
        return i18n.ftype_wiki_desc;
      case FunctionType.separator:
        return i18n.ftype_separator_desc;
      case FunctionType.bbs:
        return i18n.ftype_bbs_desc;
      case FunctionType.scanner:
        return i18n.ftype_scanner_desc;
      case FunctionType.freshman:
        return i18n.ftype_freshman_desc;
      case FunctionType.switchAccount:
        return i18n.ftype_switchAccount_desc;
      case FunctionType.board:
        return i18n.ftype_kiteBoard_desc;
      case FunctionType.electricity:
        return i18n.ftype_elecBill_desc;
    }
  }
}

/// 用户的功能列表
abstract class IUserFunctionList {
  List<FunctionType> getFunctionList();
}

/// 本、专科生默认功能列表
class UndergraduateFunctionList implements IUserFunctionList {
  @override
  List<FunctionType> getFunctionList() {
    return <FunctionType>[
      FunctionType.upgrade,
      FunctionType.notice,
      FunctionType.timetable,
      FunctionType.report,
      FunctionType.separator,
      FunctionType.exam,
      FunctionType.classroom,
      FunctionType.event,
      FunctionType.expense,
      FunctionType.electricity,
      FunctionType.score,
      FunctionType.library,
      FunctionType.office,
      FunctionType.mail,
      FunctionType.bulletin,
      FunctionType.separator,
      FunctionType.freshman,
      FunctionType.scanner,
      FunctionType.bbs,
      FunctionType.contact,
      FunctionType.game,
      FunctionType.board,
      FunctionType.wiki,
      FunctionType.separator,
    ];
  }
}

/// 研究生默认功能列表
class PostgraduateFunctionList implements IUserFunctionList {
  @override
  List<FunctionType> getFunctionList() {
    return <FunctionType>[
      FunctionType.upgrade,
      FunctionType.notice,
      FunctionType.report,
      FunctionType.separator,
      FunctionType.classroom,
      FunctionType.expense,
      FunctionType.electricity,
      FunctionType.library,
      FunctionType.office,
      FunctionType.mail,
      FunctionType.bulletin,
      FunctionType.separator,
      FunctionType.freshman,
      FunctionType.scanner,
      FunctionType.bbs,
      FunctionType.contact,
      FunctionType.game,
      FunctionType.board,
      FunctionType.wiki,
      FunctionType.separator,
    ];
  }
}

/// 教师账户默认功能列表
class TeacherFunctionList implements IUserFunctionList {
  @override
  List<FunctionType> getFunctionList() {
    return <FunctionType>[
      FunctionType.upgrade,
      FunctionType.notice,
      FunctionType.report,
      FunctionType.separator,
      FunctionType.expense,
      FunctionType.electricity,
      FunctionType.library,
      FunctionType.office,
      FunctionType.mail,
      FunctionType.bulletin,
      FunctionType.separator,
      FunctionType.scanner,
      FunctionType.bbs,
      FunctionType.contact,
      FunctionType.game,
      FunctionType.board,
      FunctionType.wiki,
      FunctionType.separator,
    ];
  }
}

/// 新生功能列表
class FreshmanFunctionList implements IUserFunctionList {
  @override
  List<FunctionType> getFunctionList() {
    return <FunctionType>[
      FunctionType.upgrade,
      FunctionType.notice,
      FunctionType.switchAccount,
      FunctionType.separator,
      FunctionType.freshman,
      FunctionType.scanner,
      FunctionType.bbs,
      FunctionType.contact,
      FunctionType.board,
      FunctionType.wiki,
      FunctionType.separator,
    ];
  }
}

class UserFunctionListFactory {
  static final _cache = HashMap<UserType, IUserFunctionList>();

  static IUserFunctionList getUserFunctionList(UserType userType) {
    if (_cache.containsKey(userType)) {
      return _cache[userType]!;
    }
    _cache[userType] = {
      UserType.undergraduate: () => UndergraduateFunctionList(),
      UserType.postgraduate: () => PostgraduateFunctionList(),
      UserType.teacher: () => TeacherFunctionList(),
      UserType.freshman: () => FreshmanFunctionList(),
    }[userType]!();

    return _cache[userType]!;
  }
}

List<FunctionType> getDefaultFunctionList(UserType userType) {
  return UserFunctionListFactory.getUserFunctionList(userType).getFunctionList();
}
