import 'package:hive/hive.dart';

import 'storage/game.dart';

class GameInitializer {
  static late GameStorage gameRecord;

  static init({required Box<dynamic> gameBox}) async {
    gameRecord = GameStorage(gameBox);
  }
}
