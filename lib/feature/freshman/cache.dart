import 'package:kite/feature/freshman/dao.dart';
import 'package:kite/feature/freshman/entity.dart';
import 'package:kite/setting/dao/freshman.dart';

class FreshmanCacheManager {
  final FreshmanCacheDao freshmanCacheDao;
  FreshmanCacheManager(this.freshmanCacheDao);

  void clearFamiliars() => freshmanCacheDao.familiars = null;
  void clearClassmates() => freshmanCacheDao.classmates = null;
  void clearRoommates() => freshmanCacheDao.roommates = null;
  void clearAnalysis() => freshmanCacheDao.analysis = null;
  void clearBasicInfo() => freshmanCacheDao.basicInfo = null;
  void clearAll() {
    clearFamiliars();
    clearClassmates();
    clearRoommates();
    clearAnalysis();
    clearBasicInfo();
  }
}

class CachedFreshmanService implements FreshmanDao {
  final FreshmanDao _freshmanDao;
  final FreshmanCacheDao _freshmanCacheDao;
  final FreshmanCacheManager _freshmanCacheManager;
  const CachedFreshmanService({
    required FreshmanDao freshmanDao,
    required FreshmanCacheDao freshmanCacheDao,
    required FreshmanCacheManager freshmanCacheManager,
  })  : _freshmanDao = freshmanDao,
        _freshmanCacheDao = freshmanCacheDao,
        _freshmanCacheManager = freshmanCacheManager;

  @override
  Future<void> update({Contact? contact, bool? visible}) async {
    await _freshmanDao.update(
      contact: contact,
      visible: visible,
    );
    // 维护缓存数据的一致性，直接清空缓存
    _freshmanCacheManager.clearBasicInfo();
  }

  Future<T> _getWithCache<T>({
    required T? Function() onReadCache, // 读缓存数据时
    required void Function(T?) onWriteCache, // 写缓存数据
    required Future<T> Function() onLoadCache, // 当缓存数据不存在时，需要加载数据
  }) async {
    var data = onReadCache();
    if (data != null) return data;
    data = await onLoadCache();
    onWriteCache(data);
    return data!;
  }

  @override
  Future<FreshmanInfo> getInfo() async {
    return _getWithCache(
      onReadCache: () => _freshmanCacheDao.basicInfo,
      onWriteCache: (e) => _freshmanCacheDao.basicInfo = e,
      onLoadCache: _freshmanDao.getInfo,
    );
  }

  @override
  Future<List<Mate>> getRoommates() {
    return _getWithCache(
      onReadCache: () => _freshmanCacheDao.roommates,
      onWriteCache: (e) => _freshmanCacheDao.roommates = e,
      onLoadCache: _freshmanDao.getRoommates,
    );
  }

  @override
  Future<List<Mate>> getClassmates() {
    return _getWithCache(
      onReadCache: () => _freshmanCacheDao.classmates,
      onWriteCache: (e) => _freshmanCacheDao.classmates = e,
      onLoadCache: _freshmanDao.getClassmates,
    );
  }

  @override
  Future<List<Familiar>> getFamiliars() {
    return _getWithCache(
        onReadCache: () => _freshmanCacheDao.familiars,
        onWriteCache: (e) => _freshmanCacheDao.familiars = e,
        onLoadCache: _freshmanDao.getFamiliars);
  }

  @override
  Future<Analysis> getAnalysis() {
    return _getWithCache(
        onReadCache: () => _freshmanCacheDao.analysis,
        onWriteCache: (e) => _freshmanCacheDao.analysis = e,
        onLoadCache: _freshmanDao.getAnalysis);
  }

  @override
  Future<void> postAnalysisLog() {
    // 装饰模式的弊端
    // 这个不用缓存，但是也得原封不动的调用被装饰对象的相应方法
    return _freshmanDao.postAnalysisLog();
  }
}
