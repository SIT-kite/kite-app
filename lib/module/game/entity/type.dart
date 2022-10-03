import 'package:hive/hive.dart';
import 'package:kite/global/hive_type_id_pool.dart';

part 'type.g.dart';

@HiveType(typeId: HiveTypeIdPool.gameTypeItem)
enum GameType {
  /// 2048 游戏
  @HiveField(0)
  game2048,

  /// Wordle 游戏
  @HiveField(1)
  wordle,

  /// 合成上应大游戏
  @HiveField(2)
  composeSit,

  /// 俄罗斯方块
  @HiveField(3)
  tetris;

  static int toIndex(GameType type) => type.index;

  static GameType fromIndex(int index) => GameType.values[index];
}
