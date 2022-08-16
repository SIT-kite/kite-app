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
import 'package:kite/setting/dao/index.dart';

part 'home.g.dart';

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
      FunctionType.library,
      FunctionType.office,
      FunctionType.mail,
      FunctionType.bulletin,
      FunctionType.separator,
      FunctionType.scanner,
      FunctionType.bbs,
      FunctionType.contact,
      FunctionType.game,
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
