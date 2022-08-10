import 'package:kite/feature/freshman/dao.dart';
import 'package:kite/feature/freshman/entity.dart';
import 'package:kite/setting/dao/freshman.dart';

class CachedFreshmanService implements FreshmanDao {
  final FreshmanDao _freshmanDao;
  final FreshmanCacheDao _freshmanCacheDao;
  CachedFreshmanService(this._freshmanDao, this._freshmanCacheDao);

  @override
  Future<Analysis> getAnalysis() {
    // TODO: 添加缓存支持
    return _freshmanDao.getAnalysis();
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
  Future<List<Mate>> getClassmates() {
    return _getWithCache(
      onReadCache: () => _freshmanCacheDao.classmates,
      onWriteCache: (e) => _freshmanCacheDao.classmates = e,
      onLoadCache: _freshmanDao.getClassmates,
    );
  }

  @override
  Future<List<Familiar>> getFamiliars() {
    // TODO: 添加缓存支持
    return _freshmanDao.getFamiliars();
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
  Future<void> postAnalysisLog() {
    // 装饰模式的弊端
    // 这个不用缓存，但是也得原封不动的调用被装饰对象的相应方法
    return _freshmanDao.postAnalysisLog();
  }

  @override
  Future<void> update({Contact? contact, bool? visible}) {
    // TODO: 这里可能需要清空某些缓存数据，以此维护数据一致性
    return _freshmanDao.update();
  }
}
