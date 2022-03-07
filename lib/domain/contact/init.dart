import 'package:hive/hive.dart';

import 'entity/contact.dart';
import 'storage/contact.dart';

class ContactInitializer {
  static late ContactDataStorage contactData;

  static init() async {
    final contactDataBox = await Hive.openBox<ContactData>('contactSetting');
    contactData = ContactDataStorage(contactDataBox);
  }
}
