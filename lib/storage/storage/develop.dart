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
import 'package:hive/hive.dart';
import 'package:kite/storage/dao/develop.dart';

class DevelopOptionsKeys {
  static const namespace = '/developOptions';
  static const showErrorInfoDialog = '$namespace/showErrorInfoDialog';
}

class DevelopOptionsStorage implements DevelopOptionsDao {
  final Box<dynamic> box;

  DevelopOptionsStorage(this.box);

  @override
  bool? get showErrorInfoDialog => box.get(DevelopOptionsKeys.showErrorInfoDialog);
  @override
  set showErrorInfoDialog(bool? foo) => box.put(DevelopOptionsKeys.showErrorInfoDialog, foo);
}
