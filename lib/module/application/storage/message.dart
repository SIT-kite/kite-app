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
import '../dao/message.dart';
import '../entity/message.dart';
import '../using.dart';

class ApplicationMessageStorageBox with CachedBox {
  @override
  final Box<dynamic> box;
  late final msgCount = Named<ApplicationMsgCount>("/messageCount");
  late final allMessages = Named<ApplicationMsgPage>("/messages");

  ApplicationMessageStorageBox(this.box);
}

class ApplicationMessageStorage extends ApplicationMessageDao {
  final ApplicationMessageStorageBox box;

  ApplicationMessageStorage(Box<dynamic> hive) : box = ApplicationMessageStorageBox(hive);

  @override
  Future<ApplicationMsgCount?> getMessageCount() async {
    return box.msgCount.value;
  }

  @override
  Future<ApplicationMsgPage?> getAllMessage() async {
    return box.allMessages.value;
  }

  void setMessageCount(ApplicationMsgCount? msgCount) {
    box.msgCount.value = msgCount;
  }

  void setAllMessage(ApplicationMsgPage? messages) {
    box.allMessages.value = messages;
  }
}
