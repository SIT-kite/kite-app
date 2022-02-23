import 'package:kite/entity/sc/detail.dart';

abstract class ScActivityDetailDao {
  Future<ActivityDetail> getActivityDetail(int activityId);
}
