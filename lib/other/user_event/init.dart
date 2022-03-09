import 'package:hive/hive.dart';
import 'package:kite/util/hive_register_adapter.dart';

import 'dao.dart';
import 'entity.dart';
import 'storage.dart';

class UserEventInitializer {
  static late UserEventStorageDao userEventStorage;

  static Future<void> init({
    required Box<dynamic> userEventBox,
  }) async {
    registerAdapter(UserEventAdapter());
    registerAdapter(UserEventTypeAdapter());
    userEventStorage = UserEventStorage(userEventBox);
  }
}
