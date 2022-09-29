import 'entity.dart';

abstract class FunctionOverrideStorageDao {
  FunctionOverrideInfo? info;
  List<int>? confirmedRouteNotice;
}

abstract class FunctionOverrideServiceDao {
  Future<FunctionOverrideInfo> get();
}
