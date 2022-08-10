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

  @override
  Future<List<Mate>> getClassmates() async {
    var mates = _freshmanCacheDao.classmates;
    if (mates != null) return mates;
    mates = await _freshmanDao.getClassmates();
    _freshmanCacheDao.classmates = mates;
    return mates;
  }

  @override
  Future<List<Familiar>> getFamiliars() {
    // TODO: 添加缓存支持
    return _freshmanDao.getFamiliars();
  }

  @override
  Future<FreshmanInfo> getInfo() async {
    // 如果有缓存，直接返回
    var info = _freshmanCacheDao.basicInfo;
    if (info != null) return info;

    // 否则没有缓存，先请求一次
    info = await _freshmanDao.getInfo();
    _freshmanCacheDao.basicInfo = info; // 缓存
    return info;
  }

  @override
  Future<List<Mate>> getRoommates() {
    // TODO: 添加缓存支持
    return _freshmanDao.getRoommates();
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
