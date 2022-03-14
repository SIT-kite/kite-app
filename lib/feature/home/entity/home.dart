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

import 'package:hive_flutter/hive_flutter.dart';
import 'package:kite/global/hive_type_id_pool.dart';

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
}

/// 默认首页布局, 千万不能漏
const defaultFunctionList = <FunctionType>[
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
  FunctionType.bbs,
  FunctionType.contact,
  FunctionType.game,
  FunctionType.wiki,
  FunctionType.separator,
];
