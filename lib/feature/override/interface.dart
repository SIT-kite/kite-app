import 'entity.dart';

abstract class FunctionOverrideStorageDao {
  FunctionOverrideInfo? info;
}

abstract class FunctionOverrideServiceDao {
  Future<FunctionOverrideInfo> get();
}
