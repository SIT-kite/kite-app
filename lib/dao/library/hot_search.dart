import 'package:kite/entity/library/hot_search.dart';

/// 热搜的数据访问接口
abstract class HotSearchDao {
  Future<HotSearch> getHotSearch();
}
