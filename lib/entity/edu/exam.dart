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
import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';

part 'exam.g.dart';

@JsonSerializable()
class ExamRoom {
  @JsonKey(name: 'kcmc')
  // 课程名称
  String courseName = "";
  @JsonKey(name: 'kssj', fromJson: _stringToList)
  // 考试时间
  List<DateTime> time = [];
  @JsonKey(name: 'cdmc')
  // 考试地点
  String place = "";
  @JsonKey(name: 'cdxqmc')
  // 考试校区
  String campus = "";
  @JsonKey(name: 'zwh', fromJson: _stringToInt)
  // 考试座号
  int seatNumber = 0;
  @JsonKey(name: 'cxbj')
  // 是否重修
  String isRebuild = "";

  ExamRoom();

  factory ExamRoom.fromJson(Map<String, dynamic> json) => _$ExamRoomFromJson(json);

  Map<String, dynamic> toJson() => _$ExamRoomToJson(this);

  @override
  String toString() {
    return 'ExamRoom{courseName: $courseName, time: $time, place: $place, campus: $campus, seatNumber: $seatNumber, isRebuild: $isRebuild}';
  }

  static int _stringToInt(String s) => int.tryParse(s) ?? 0;

  static List<DateTime> _stringToList(String s) {
    List<DateTime> result = [];
    var dateformat = DateFormat('yyyy-MM-dd hh:mm');
    var date = s.split('(')[0];
    var time = s.split('(')[1].replaceAll(')', '');
    String start = date + ' ' + time.split('-')[0];
    String end = date + ' ' + time.split('-')[1];
    var startTime = dateformat.parse(start);
    var endTime = dateformat.parse(end);
    result.add(startTime);
    result.add(endTime);
    return result;
  }
}
