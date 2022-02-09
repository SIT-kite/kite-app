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
class ActivityDetail {
  /// Activity id
  final int id;

  /// Category id
  final int category;

  /// Activity title
  final String title;

  /// Activity start time
  final DateTime startTime;

  /// Sign start time
  final DateTime signStartTime;

  /// Sign end time
  final DateTime signEndTime;

  /// Place
  final String place;

  /// Duration
  final String duration;

  /// Activity manager
  final String manager;

  /// Manager contact(phone)
  final String contact;

  /// Activity organizer
  final String organizer;

  /// Activity undertaker
  final String undertaker;

  /// Description in text[]
  final String description;

  /// Image attachment
  final List<ScImages> images;

  const ActivityDetail(
      this.id,
      this.category,
      this.title,
      this.startTime,
      this.signStartTime,
      this.signEndTime,
      this.place,
      this.duration,
      this.manager,
      this.contact,
      this.organizer,
      this.undertaker,
      this.description,
      this.images);

  @override
  String toString() {
    return 'ActivityDetail{id: $id, category: $category, title: $title, '
        'startTime: $startTime, signStartTime: $signStartTime, '
        'signEndTime: $signEndTime, place: $place, duration: $duration,'
        'manager: $manager, contact: $contact, organizer: $organizer,'
        ' undertaker: $undertaker, description: $description, images: $images}';
  }
}

class ScImages {
  /// New image name
  final String newName;

  /// Old image name
  final String oldName;

  /// Image content
  final List<int> content;

  const ScImages(this.newName, this.oldName, this.content);

  @override
  String toString() {
    return 'ScImages{newName: $newName, oldName: $oldName, content: $content}';
  }
}
