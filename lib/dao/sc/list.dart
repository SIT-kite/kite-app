import 'package:kite/entity/sc/list.dart';

abstract class ScActivityListDao {
  Future<List<Activity>> getActivityList();
}
