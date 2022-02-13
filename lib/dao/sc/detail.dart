import 'package:kite/entity/sc/detail.dart';

abstract class ScActivityDetailDao {
  Future<List<ActivityDetail>> getActivityDetail();
}
