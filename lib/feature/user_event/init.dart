import 'package:hive/hive.dart';

import 'dao.dart';
import 'storage.dart';

class UserEventInitializer {
  static late UserEventStorageDao userEventStorage;

  static Future<void> init({
    required Box<dynamic> userEventBox,
  }) async {
    userEventStorage = UserEventStorage(userEventBox);
  }
}
