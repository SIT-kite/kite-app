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
import 'dart:ui';

import 'package:hive/hive.dart';

import '../type_id.dart';

/// There is no need to consider revision
class ColorAdapter extends TypeAdapter<Color> {
  @override
  final int typeId = HiveTypeId.color;

  @override
  Color read(BinaryReader reader) {
    final hex = reader.readInt();
    return Color(hex);
  }

  @override
  void write(BinaryWriter writer, Color obj) {
    writer.writeInt(obj.value);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is ColorAdapter && runtimeType == other.runtimeType && typeId == other.typeId;
}
