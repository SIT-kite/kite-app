import 'entity.dart';

abstract class FunctionOverrideStorageDao {
  FunctionOverrideInfo? cache;
  List<int>? confirmedRouteNotice;
}

abstract class FunctionOverrideServiceDao {
  Future<FunctionOverrideInfo> get();
}
