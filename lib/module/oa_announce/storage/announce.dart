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
import 'package:kite/module/activity/using.dart';

import '../dao/announce.dart';
import '../entity/announce.dart';
import '../entity/page.dart';

class _Key {
  static const catalogues = "/catalogues";
  static const detailsNs = "/details";
}

class AnnounceStorageBox with CachedBox {
  @override
  final Box box;
  late final catalogues = NamedList<AnnounceCatalogue>(_Key.catalogues);
  late final details = Namespace2<AnnounceDetail, String, String>(_Key.detailsNs, makeDetailKey);

  static String makeDetailKey(String catalogueId, String uuid) => "$catalogueId/$uuid";

  AnnounceStorageBox(this.box);
}

class AnnounceStorage extends AnnounceDao {
  final AnnounceStorageBox box;

  AnnounceStorage(Box<dynamic> hive) : box = AnnounceStorageBox(hive);

  /// 获取所有的分类信息
  @override
  Future<List<AnnounceCatalogue>?> getAllCatalogues() async {
    return box.catalogues.value;
  }

  /// 获取某篇文章内容
  @override
  Future<AnnounceDetail?> getAnnounceDetail(String catalogueId, String uuid) async {
    final details = box.details.make(catalogueId, uuid);
    return details.value;
  }

  void setAnnounceDetail(String catalogueId, String uuid, AnnounceDetail? detail) {
    final details = box.details.make(catalogueId, uuid);
    details.value = detail;
  }

  /// 检索文章列表
  @override
  Future<AnnounceListPage?> queryAnnounceList(int pageIndex, String catalogueId) async {
    throw UnimplementedError("Storage won't query.");
  }

  void setAllCatalogues(List<AnnounceCatalogue>? catalogues) {
    box.catalogues.value = catalogues;
  }
}
