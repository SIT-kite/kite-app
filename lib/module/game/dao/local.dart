import '../entity/record.dart';

/// 游戏记录访问接口
abstract class GameRecordStorageDao {
  /// 添加游戏记录
  void append(GameRecord record);

  /// 获取最近一次游戏记录 (首页)
  GameRecord? getLastOne();

  /// 清空游戏记录存储
  void deleteAll();

  /// 获取所有游戏成绩记录
  List<GameRecord> getAllRecords();
}
