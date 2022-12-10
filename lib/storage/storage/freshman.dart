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

import 'package:hive_flutter/hive_flutter.dart';
import 'package:kite/module/freshman/entity/info.dart';
import 'package:kite/module/freshman/entity/relationship.dart';
import 'package:kite/module/freshman/entity/statistics.dart';

import '../dao/freshman.dart';
import 'common.dart';

class FreshmanCacheKeys {
  static const namespace = '/freshman';
  static const basicInfo = '$namespace/cache/basicInfo';
  static const classmates = '$namespace/cache/classmates';
  static const roommates = '$namespace/cache/roommates';
  static const analysis = '$namespace/cache/analysis';
  static const familiars = '$namespace/cache/familiars';

  static const authName = '$namespace/auth/name';

  static const disableFirstEnterDialogState = '$namespace/state/disableFirstEnterDialog';
}

class FreshmanCacheStorage implements FreshmanCacheDao {
  final JsonStorage jsonStorage;
  final Box<dynamic> box;

  FreshmanCacheStorage(this.box) : jsonStorage = JsonStorage(box);

  @override
  Analysis? get analysis => jsonStorage.getModel(FreshmanCacheKeys.analysis, Analysis.fromJson);

  @override
  set analysis(Analysis? foo) => jsonStorage.setModel<Analysis>(FreshmanCacheKeys.analysis, foo, (e) => e.toJson());

  @override
  FreshmanInfo? get basicInfo => jsonStorage.getModel(FreshmanCacheKeys.basicInfo, FreshmanInfo.fromJson);

  @override
  set basicInfo(FreshmanInfo? foo) =>
      jsonStorage.setModel<FreshmanInfo>(FreshmanCacheKeys.basicInfo, foo, (e) => e.toJson());

  @override
  List<Familiar>? get familiars => jsonStorage.getModelList(FreshmanCacheKeys.familiars, Familiar.fromJson);

  @override
  set familiars(List<Familiar>? foo) =>
      jsonStorage.setModelList<Familiar>(FreshmanCacheKeys.familiars, foo, (e) => e.toJson());

  @override
  List<Mate>? get classmates => jsonStorage.getModelList(FreshmanCacheKeys.classmates, Mate.fromJson);

  @override
  set classmates(List<Mate>? foo) =>
      jsonStorage.setModelList<Mate>(FreshmanCacheKeys.classmates, foo, (e) => e.toJson());

  @override
  List<Mate>? get roommates => jsonStorage.getModelList(FreshmanCacheKeys.roommates, Mate.fromJson);

  @override
  set roommates(List<Mate>? foo) => jsonStorage.setModelList<Mate>(FreshmanCacheKeys.roommates, foo, (e) => e.toJson());

  @override
  String? get freshmanName => box.get(FreshmanCacheKeys.authName);

  @override
  set freshmanName(String? foo) => box.put(FreshmanCacheKeys.authName, foo);

  @override
  bool? get disableFirstEnterDialogState => box.get(FreshmanCacheKeys.disableFirstEnterDialogState);

  @override
  set disableFirstEnterDialogState(bool? foo) => box.put(FreshmanCacheKeys.disableFirstEnterDialogState, foo);
}
