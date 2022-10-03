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
import 'package:kite/storage/storage/common.dart';

import 'entity.dart';
import 'interface.dart';

class FunctionOverrideKeys {
  static const namespace = "/override";
  static const cache = "$namespace/cache";
  static const confirmedRouteNotice = "$namespace/confirmedRouteNotice";
}

class FunctionOverrideStorage extends JsonStorage implements FunctionOverrideStorageDao {
  FunctionOverrideStorage(super.box);

  @override
  FunctionOverrideInfo? get cache => getModel(FunctionOverrideKeys.cache, FunctionOverrideInfo.fromJson);

  @override
  set cache(FunctionOverrideInfo? foo) =>
      setModel<FunctionOverrideInfo>(FunctionOverrideKeys.cache, foo, (e) => e.toJson());

  @override
  List<int>? get confirmedRouteNotice => super.box.get(FunctionOverrideKeys.confirmedRouteNotice);

  @override
  set confirmedRouteNotice(List<int>? foo) => super.box.put(FunctionOverrideKeys.confirmedRouteNotice, foo);
}
