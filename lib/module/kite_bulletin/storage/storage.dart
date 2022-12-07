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
import 'package:hive/hive.dart';
import 'package:kite/module/kite_bulletin/dao/local.dart';
import 'package:kite/module/kite_bulletin/entity/bulletin.dart';
import 'package:kite/util/json_storage.dart';

class _Key {
  static const _namespace = '/bulletin';
  static const data = '$_namespace/data';
  static const meta = '$_namespace/meta';
}

class KiteBulletinStorage implements KiteBulletinStorageDao {
  final JsonStorage jsonStorage;
  KiteBulletinStorage(Box box) : jsonStorage = JsonStorage(box);

  @override
  List<KiteBulletin> get data => jsonStorage.getModelList(_Key.data, KiteBulletin.fromJson) ?? [];
  @override
  set data(List<KiteBulletin> v) => jsonStorage.setModelList(_Key.data, v, (e) => e.toJson());

  @override
  KiteBulletinMeta? get meta => jsonStorage.getModel(_Key.meta, KiteBulletinMeta.fromJson);

  @override
  set meta(KiteBulletinMeta? meta) => jsonStorage.setModel(_Key.meta, meta, (e) => e.toJson());
}
