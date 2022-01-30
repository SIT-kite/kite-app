import 'package:kite/session/abstract_session.dart';
import 'package:kite/service/abstract_service.dart';
import 'package:kite/global/storage_pool.dart';
import 'package:kite/dao/contact.dart';
import 'package:kite/entity/contact.dart';

class ContactRemoteService extends AService implements ConstantRemoteDao {
  static const _contactUrl = "https://kite.sunnysab.cn/api/v2/contact";

  ContactRemoteService(ASession session) : super(session);
  @override
  Future<List<ContactData>> getContactData() async {
    final response = await session.get(_contactUrl);
    final List contactList = response.data['data'];
    List<ContactData> result =
        contactList.map((e) => ContactData.fromJson(e)).toList();
    for (ContactData contactData in result) {
      StoragePool.contactData.add(contactData);
    }
    return result;
  }
}
