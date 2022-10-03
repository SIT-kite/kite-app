import '../entity/rank.dart';
import '../entity/record.dart';

abstract class RankingServiceDao {
  /// 获取游戏排名
  Future<List<GameRankingItem>> getGameRanking(int gameId);

  /// 上传用户成绩
  Future<void> postScore(GameRecord record);
}
