import 'entity.dart';
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
    if (storageDao.cache != null) return storageDao.cache!;
    final data = await serviceDao.get();
    storageDao.cache = data;
    return data;
  }
}
