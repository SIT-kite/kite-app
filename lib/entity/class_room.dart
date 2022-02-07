import 'package:json_annotation/json_annotation.dart';

part 'class_room.g.dart';

@JsonSerializable()
class ClassRoomData {
  ///空闲时间
  final int busyTime;

  ///教室容量
  final int? capacity;

  ///教室号
  final String room;

  ClassRoomData(this.busyTime, this.capacity, this.room);
  factory ClassRoomData.fromJson(Map<String, dynamic> json) =>
      _$ClassRoomDataFromJson(json);
}
