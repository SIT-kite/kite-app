import 'package:kite/storage/storage/common.dart';

import 'entity.dart';
import 'interface.dart';

class FunctionOverrideKeys {
  static const namespace = "/override";
  static const cache = "$namespace/cache";
  static const confirmedRouteNotice = "$namespace/confirmedRouteNotice";
}

class FunctionOverrideStorage extends JsonStorage implements FunctionOverrideStorageDao {
  FunctionOverrideStorage(super.box);

  @override
  FunctionOverrideInfo? get cache => getModel(FunctionOverrideKeys.cache, FunctionOverrideInfo.fromJson);

  @override
  set cache(FunctionOverrideInfo? foo) =>
      setModel<FunctionOverrideInfo>(FunctionOverrideKeys.cache, foo, (e) => e.toJson());

  @override
  List<int>? get confirmedRouteNotice => super.box.get(FunctionOverrideKeys.confirmedRouteNotice);

  @override
  set confirmedRouteNotice(List<int>? foo) => super.box.put(FunctionOverrideKeys.confirmedRouteNotice, foo);
}
