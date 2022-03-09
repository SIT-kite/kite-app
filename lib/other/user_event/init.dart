import 'package:hive/hive.dart';
import 'package:kite/util/hive_register_adapter.dart';

import 'dao.dart';
import 'entity.dart';
import 'storage.dart';

class UserEventInitializer {
  static late UserEventStorageDao userEventStorage;

  static Future<void> init({String hiveBoxName = 'userEvent'}) async {
    registerAdapter(UserEventAdapter());
    registerAdapter(UserEventTypeAdapter());
    final userEventBox = await Hive.openBox<dynamic>(hiveBoxName);
    userEventStorage = UserEventStorage(userEventBox);
  }
}
