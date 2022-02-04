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
import 'package:kite/dao/contact.dart';
import 'package:kite/entity/contact.dart';
import 'package:kite/global/storage_pool.dart';
import 'package:kite/service/abstract_service.dart';
import 'package:kite/session/abstract_session.dart';

class ContactRemoteService extends AService implements ConstantRemoteDao {
  static const _contactUrl = "https://kite.sunnysab.cn/api/v2/contact";

  ContactRemoteService(ASession session) : super(session);

  @override
  Future<List<ContactData>> getContactData() async {
    final response = await session.get(_contactUrl);
    final List contactList = response.data['data'];
    List<ContactData> result = contactList.map((e) => ContactData.fromJson(e)).toList();
    for (ContactData contactData in result) {
      StoragePool.contactData.add(contactData);
    }
    return result;
  }
}
