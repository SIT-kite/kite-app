import 'package:kite/storage/storage/common.dart';

import 'entity.dart';
import 'interface.dart';

class FunctionOverrideKeys {
  static const namespace = "/override";
  static const info = "$namespace/info";
}

class FunctionOverrideStorage extends JsonStorage implements FunctionOverrideStorageDao {
  FunctionOverrideStorage(super.box);

  @override
  FunctionOverrideInfo? get info => getModel(FunctionOverrideKeys.info, FunctionOverrideInfo.fromJson);

  @override
  set info(FunctionOverrideInfo? foo) =>
      setModel<FunctionOverrideInfo>(FunctionOverrideKeys.info, foo, (e) => e.toJson());
}
