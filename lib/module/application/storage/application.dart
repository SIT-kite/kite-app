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
import 'package:kite/cache/box.dart';

import '../dao/application.dart';
import '../entity/application.dart';
import '../using.dart';

class ApplicationStorageBox with CachedBox {
  @override
  final Box<dynamic> box;
  late final details = Namespace<ApplicationDetail, String>("/details", makeDetailsKey);
  late final metas = NamedList<ApplicationMeta>("/metas");

  String makeDetailsKey(String applicationId) => applicationId;

  ApplicationStorageBox(this.box);
}

class ApplicationStorage extends ApplicationDao {
  final ApplicationStorageBox box;

  ApplicationStorage(Box<dynamic> hive) : box = ApplicationStorageBox(hive);

  @override
  Future<List<ApplicationMeta>?> getApplicationMetas() async {
    return box.metas.value;
  }

  void setApplicationMetas(List<ApplicationMeta>? metas) {
    box.metas.value = metas;
  }

  @override
  Future<ApplicationDetail?> getApplicationDetail(String applicationId) async {
    final cacheKey = box.details.make(applicationId);
    return cacheKey.value;
  }

  void setApplicationDetail(String applicationId, ApplicationDetail? detail) {
    final cacheKey = box.details.make(applicationId);
    cacheKey.value = detail;
  }
}
