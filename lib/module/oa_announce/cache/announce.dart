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
import 'package:kite/module/oa_announce/entity/announce.dart';
import 'package:kite/module/oa_announce/entity/page.dart';

import '../dao/announce.dart';
import '../storage/announce.dart';

class AnnounceCache extends AnnounceDao {
  final AnnounceDao from;
  final AnnounceStorage to;
  Duration detailExpire;
  Duration catalogueExpire;

  AnnounceCache({
    required this.from,
    required this.to,
    this.detailExpire = const Duration(minutes: 10),
    this.catalogueExpire = const Duration(minutes: 10),
  });

  final Map<String, AnnounceListPage?> _queried = {};

  @override
  Future<List<AnnounceCatalogue>?> getAllCatalogues() async {
    final cacheKey = to.box.catalogues;
    if (cacheKey.needRefresh(after: detailExpire)) {
      try {
        final res = await from.getAllCatalogues();
        to.setAllCatalogues(res);
        return res;
      } catch (e) {
        return to.getAllCatalogues();
      }
    } else {
      return to.getAllCatalogues();
    }
  }

  @override
  Future<AnnounceDetail?> getAnnounceDetail(String catalogueId, String uuid) async {
    final cacheKey = to.box.details.make(catalogueId, uuid);
    if (cacheKey.needRefresh(after: detailExpire)) {
      try {
        final res = await from.getAnnounceDetail(catalogueId, uuid);
        to.setAnnounceDetail(catalogueId, uuid, res);
        return res;
      } catch (e) {
        return to.getAnnounceDetail(catalogueId, uuid);
      }
    } else {
      return to.getAnnounceDetail(catalogueId, uuid);
    }
  }

  @override
  Future<AnnounceListPage?> queryAnnounceList(int pageIndex, String catalogueId) async {
    final key = "$pageIndex&$catalogueId";
    var res = _queried[key];
    res ??= await from.queryAnnounceList(pageIndex, catalogueId);
    _queried[key] = res;
    return res;
  }
}
