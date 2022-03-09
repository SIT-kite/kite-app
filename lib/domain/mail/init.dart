import 'package:hive/hive.dart';

import 'dao/mail.dart';
import 'storage/mail.dart';

class MailInitializer {
  static late MailStorageDao mail;

  static Future<void> init() async {
    final mailStorage = await Hive.openBox<dynamic>('mail');
    mail = MailStorage(mailStorage);
  }
}
