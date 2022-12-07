/*
 *    上应小风筝(SIT-kite)  便利校园，一步到位
 *    Copyright (C) 2022 上海应用技术大学 上应小风筝团队
 *
 *    This program is free software: you can redistribute it and/or modify
 *    it under the terms of the GNU General Public License as published by
 *    the Free Software Foundation, either version 3 of the License, or
 *    (at your option) any later version.
 *
 *    This program is distributed in the hope that it will be useful,
 *    but WITHOUT ANY WARRANTY; without even the implied warranty of
 *    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *    GNU General Public License for more details.
 *
 *    You should have received a copy of the GNU General Public License
 *    along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/
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
