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
import '../entity/user_event.dart';

abstract class UserEventStorageDao {
  String? get uuid;

  set uuid(String? uuid);

  /// 获取本地事件总数
  int getEventCount();

  /// 获取事件列表
  List<UserEvent> getEvents();

  /// 清除本地所有事件
  void clear();

  /// 追加事件记录
  void append(UserEvent event);

  /// 追加多条事件记录
  void appendAll(List<UserEvent> eventList);
}
