import 'package:kite/feature/override/entity.dart';

import 'interface.dart';

class FunctionOverrideCachedService implements FunctionOverrideServiceDao {
  FunctionOverrideServiceDao serviceDao;
  FunctionOverrideStorageDao storageDao;

  FunctionOverrideCachedService({
    required this.serviceDao,
    required this.storageDao,
  });
  @override
  Future<FunctionOverrideInfo> get() async {
    if (storageDao.info != null) return storageDao.info!;
    final data = await serviceDao.get();
    storageDao.info = data;
    return data;
  }
}
