/*
 * 上应小风筝  便利校园，一步到位
 * Copyright (C) 2022 上海应用技术大学 上应小风筝团队
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

import 'using.dart';

import 'dao/Freshman.dart';
import 'entity/info.dart';
import 'entity/relationship.dart';
import 'entity/statistics.dart';

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
  Future<void> updateMyContact({Contact? contact, bool? visible}) async {
    await _freshmanDao.updateMyContact(
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
  Future<FreshmanInfo> getMyInfo({FreshmanCredential? credential}) async {
    return _getWithCache(
      onReadCache: () => _freshmanCacheDao.basicInfo,
      onWriteCache: (e) => _freshmanCacheDao.basicInfo = e,
      onLoadCache: _freshmanDao.getMyInfo,
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
