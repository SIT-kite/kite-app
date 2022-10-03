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
    return 'Familiar{name: $name, college: $college, gender: $gender, city: $city, avatar: $avatar, lastSeen: $lastSeen, contact: $contact}';
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
    return 'Mate{college: $college, major: $major, name: $name, building: $building, room: $room, bed: $bed, gender: $gender, province: $province, lastSeen: $lastSeen, avatar: $avatar, contact: $contact}';
  }
}
