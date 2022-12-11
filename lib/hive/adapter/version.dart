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
import 'package:version/version.dart';

import '../type_id.dart';

class VersionAdapter extends TypeAdapter<Version> {
  @override
  final int typeId = HiveTypeId.version;

  @override
  Version read(BinaryReader reader) {
    final major = reader.readInt();
    final minor = reader.readInt();
    final patch = reader.readInt();
    final build = reader.readString();
    return Version(major, minor, patch, build: build);
  }

  @override
  void write(BinaryWriter writer, Version obj) {
    writer.writeInt(obj.major);
    writer.writeInt(obj.minor);
    writer.writeInt(obj.patch);
    writer.writeString(obj.build);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is VersionAdapter && runtimeType == other.runtimeType && typeId == other.typeId;
}
