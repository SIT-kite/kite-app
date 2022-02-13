import 'package:kite/entity/sc/detail.dart';

abstract class ScDetailDao {
  Future<List<ActivityDetail>> getActivityDetail();
}
