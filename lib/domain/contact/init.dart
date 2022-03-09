import 'package:hive/hive.dart';
import 'package:kite/abstract/abstract_session.dart';
import 'package:kite/util/hive_register_adapter.dart';

import 'dao/contact.dart';
import 'entity/contact.dart';
import 'service/contact.dart';
import 'storage/contact.dart';

class ContactInitializer {
  static late ContactStorageDao contactStorageDao;
  static late ContactRemoteDao contactRemoteDao;

  static Future<void> init(ASession session) async {
    registerAdapter(ContactDataAdapter());
    final contactDataBox = await Hive.openBox<ContactData>('contactSetting');
    contactStorageDao = ContactDataStorage(contactDataBox);
    contactRemoteDao = ContactRemoteService(session);
  }
}
