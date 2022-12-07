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

import '../using.dart';

part 'detail.g.dart';

@HiveType(typeId: HiveTypeId.activityDetail)
class ActivityDetail {
  /// Activity id
  @HiveField(0)
  final int id;

  /// Category id
  @HiveField(1)
  final int category;

  /// Activity title
  @HiveField(2)
  final String title;

  /// Activity start time
  @HiveField(3)
  final DateTime startTime;

  /// Sign start time
  @HiveField(4)
  final DateTime signStartTime;

  /// Sign end time
  @HiveField(5)
  final DateTime signEndTime;

  /// Place
  @HiveField(6)
  final String? place;

  /// Duration
  @HiveField(7)
  final String? duration;

  /// Activity manager
  @HiveField(8)
  final String? principal;

  /// Manager yellow_pages(phone)
  @HiveField(9)
  final String? contactInfo;

  /// Activity organizer
  @HiveField(10)
  final String? organizer;

  /// Activity undertaker
  @HiveField(11)
  final String? undertaker;

  /// Description in text[]
  @HiveField(12)
  final String? description;

  const ActivityDetail(this.id, this.category, this.title, this.startTime, this.signStartTime, this.signEndTime,
      this.place, this.duration, this.principal, this.contactInfo, this.organizer, this.undertaker, this.description);

  const ActivityDetail.named(
      {required this.id,
      required this.category,
      required this.title,
      required this.startTime,
      required this.signStartTime,
      required this.signEndTime,
      this.place,
      this.duration,
      this.principal,
      this.contactInfo,
      this.organizer,
      this.undertaker,
      this.description});

  @override
  String toString() {
    return 'ActivityDetail{id: $id, category: $category, title: $title, '
        'startTime: $startTime, signStartTime: $signStartTime, '
        'signEndTime: $signEndTime, place: $place, duration: $duration,'
        'principal: $principal, contactInfo: $contactInfo, organizer: $organizer,'
        ' undertaker: $undertaker, description: $description}';
  }
}
