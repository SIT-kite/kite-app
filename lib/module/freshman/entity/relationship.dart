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
import 'package:json_annotation/json_annotation.dart';

import 'info.dart';
part 'relationship.g.dart';

@JsonSerializable()
class Familiar {
  String name = '';
  String college = '';
  String gender = '';

  String? city;
  String? avatar;
  DateTime? lastSeen;
  Contact? contact;

  Familiar();

  factory Familiar.fromJson(Map<String, dynamic> json) => _$FamiliarFromJson(json);

  Map<String, dynamic> toJson() => _$FamiliarToJson(this);

  @override
  String toString() {
    return 'Familiar{name: $name, college: $college, gender: $gender, city: $city, avatar: $avatar, lastSeen: $lastSeen, yellow_pages: $contact}';
  }
}

@JsonSerializable()
class Mate {
  String college = '';
  String major = '';
  String name = '';
  String building = '';
  int room = 0;
  String bed = '';
  String gender = '';

  String? province;
  DateTime? lastSeen;
  String? avatar;
  Contact? contact;

  Mate();

  factory Mate.fromJson(Map<String, dynamic> json) => _$MateFromJson(json);

  Map<String, dynamic> toJson() => _$MateToJson(this);

  @override
  String toString() {
    return 'Mate{college: $college, major: $major, name: $name, building: $building, room: $room, bed: $bed, gender: $gender, province: $province, lastSeen: $lastSeen, avatar: $avatar, yellow_pages: $contact}';
  }
}
