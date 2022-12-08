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
import '../storage/message.dart';

class ApplicationMessageCache implements ApplicationMessageDao {
  final ApplicationMessageDao from;
  final ApplicationMessageStorage to;
  Duration expiration;

  ApplicationMessageCache({
    required this.from,
    required this.to,
    this.expiration = const Duration(minutes: 10),
  });

  @override
  Future<ApplicationMsgCount?> getMessageCount() async {
    if (to.box.msgCount.needRefresh(after: expiration)) {
      try {
        final res = await from.getMessageCount();
        to.setMessageCount(res);
        return res;
      } catch (e) {
        return to.getMessageCount();
      }
    } else {
      return to.getMessageCount();
    }
  }

  @override
  Future<ApplicationMsgPage?> getAllMessage() async {
    if (to.box.allMessages.needRefresh(after: expiration)) {
      try {
        final res = await from.getAllMessage();
        to.setAllMessage(res);
        return res;
      } catch (e) {
        return to.getAllMessage();
      }
    } else {
      return to.getAllMessage();
    }
  }
}
