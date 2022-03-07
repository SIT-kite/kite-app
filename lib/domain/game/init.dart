import 'package:hive/hive.dart';
import 'package:kite/util/hive_register_adapter.dart';

import 'entity/game.dart';
import 'storage/game.dart';

class GameInitializer {
  static late GameStorage gameRecord;

  static init() async {
    registerAdapter(GameTypeAdapter());
    registerAdapter(GameRecordAdapter());
    final gameStorage = await Hive.openBox<dynamic>('game');
    gameRecord = GameStorage(gameStorage);
  }
}
