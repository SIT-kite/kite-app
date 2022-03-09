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
import 'package:hive/hive.dart';
import 'package:kite/domain/kite/dao/user_event.dart';
import 'package:kite/domain/kite/entity/user_event.dart';

class UserEventStorage implements UserEventStorageDao {
  final Box<dynamic> box;

  const UserEventStorage(this.box);

  @override
  String? get uuid => box.get('uuid');

  @override
  set uuid(String? uuid) => box.put('uuid', uuid);

  @override
  void append(UserEvent event) => box.add(event);

  @override
  void clear() {
    final u = uuid;
    box.clear();
    uuid = u;
  }

  @override
  int getEventCount() => box.length;

  @override
  List<UserEvent> getEvents() =>
      box.values.where((element) => element.runtimeType == UserEvent).map((e) => e as UserEvent).toList();

  @override
  void appendAll(List<UserEvent> eventList) => box.addAll(eventList);
}
