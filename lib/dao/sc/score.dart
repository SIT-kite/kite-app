import 'package:kite/entity/sc/score.dart';

abstract class ScScoreDao {
  Future<ScScoreSummary> getScScoreSummary();

  Future<List<ScScoreItem>> getMyScoreList();

  Future<List<ScActivityItem>> getMyActivityList();
}
