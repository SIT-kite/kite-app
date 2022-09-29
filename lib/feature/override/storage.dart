import 'package:kite/storage/storage/common.dart';

import 'entity.dart';
import 'interface.dart';

class FunctionOverrideKeys {
  static const namespace = "/override";
  static const info = "$namespace/info";
  static const confirmedRouteNotice = "$namespace/confirmedRouteNotice";
}

class FunctionOverrideStorage extends JsonStorage implements FunctionOverrideStorageDao {
  FunctionOverrideStorage(super.box);

  @override
  FunctionOverrideInfo? get info => getModel(FunctionOverrideKeys.info, FunctionOverrideInfo.fromJson);

  @override
  set info(FunctionOverrideInfo? foo) =>
      setModel<FunctionOverrideInfo>(FunctionOverrideKeys.info, foo, (e) => e.toJson());

  @override
  List<int>? get confirmedRouteNotice => super.box.get(FunctionOverrideKeys.confirmedRouteNotice);

  @override
  set confirmedRouteNotice(List<int>? foo) => super.box.put(FunctionOverrideKeys.confirmedRouteNotice, foo);
}
