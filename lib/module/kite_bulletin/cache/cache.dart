import 'package:kite/module/kite_bulletin/dao/remote.dart';
import 'package:kite/module/kite_bulletin/entity/bulletin.dart';

import '../dao/local.dart';

class CachedKiteBulletinService implements KiteBulletinServiceDao {
  final KiteBulletinStorageDao storage;
  final KiteBulletinServiceDao service;

  KiteBulletinMeta? _memCachedMeta;

  CachedKiteBulletinService({
    required this.storage,
    required this.service,
  });

  @override
  Future<KiteBulletinMeta> getBulletinMeta() async {
    // 内存里的meta缓存只有重启了才会更新
    if (_memCachedMeta != null) return _memCachedMeta!;

    final meta = await service.getBulletinMeta();
    _memCachedMeta = meta;
    return meta;
  }

  @override
  Future<List<KiteBulletin>> getSortedBulletinList() async {
    // 先获取元数据
    _memCachedMeta ??= await getBulletinMeta();

    // 如果hash未更新直接读取本地缓存
    if (storage.meta != null && _memCachedMeta!.hash == storage.meta!.hash) return storage.data;

    // 存在更新，那么获取更新数据
    final data = await service.getSortedBulletinList();

    // 持久化
    storage
      ..data = data
      ..meta = _memCachedMeta!;

    return data;
  }
}
