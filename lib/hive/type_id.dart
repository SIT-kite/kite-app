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

/// 存放所有 hive 的自定义类型的typeId
class HiveTypeId {
  HiveTypeId._();

  static const librarySearchHistory = 1;
  static const auth = 2; // 改为单用户后已不再使用该id
  static const weather = 3;
  static const reportHistory = 4;
  static const balance = 5;
  static const course = 6;
  static const expense = 7;
  static const expenseType = 8;
  static const contact = 9;
  static const userEventType = 10;
  static const userEvent = 11;
  static const gameType = 12;
  static const gameRecord = 13;
  static const ftype = 14;
  static const timetableMeta = 15;
  static const size = 16;
  static const color = 17;

  // Activity
  static const activityDetail = 18;
  static const activity = 19;
  static const scScoreSummary = 20;
  static const scActivityApplication = 21;
  static const scScoreItem = 22;
  static const activityType = 23;

  // Exam Arrangement
  static const examEntry = 24;

  // OA Announcement
  static const announceDetail = 25;
  static const announceAttachment = 26;
  static const announceCatalogue = 27;
  static const announceListPage = 28;
  static const announceRecord = 29;
}
