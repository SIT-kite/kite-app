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

enum FunctionType {
  /// 升级
  upgrade,

  /// 公告
  notice,

  /// 课程表
  timetable,

  /// 体温上报
  report,

  /// 考试安排
  exam,

  /// 空教室
  classroom,

  /// 活动
  event,

  /// 消费查询
  expense,

  /// 成绩查询
  score,

  /// 图书馆
  library,

  /// 办公
  office,

  /// Edu 邮箱
  mail,

  /// OA 公告
  bulletin,

  /// 常用电话
  contact,

  /// 小游戏
  game,

  /// wiki
  wiki,

  /// 分隔符
  separator,
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
  FunctionType.contact,
  FunctionType.game,
  FunctionType.wiki,
  FunctionType.separator,
];
