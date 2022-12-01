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
import 'package:json_annotation/json_annotation.dart';

import '../using.dart';

part 'contact.g.dart';

@JsonSerializable()
@HiveType(typeId: HiveTypeIdPool.contactItem)
class ContactData {
  ///部门
  @HiveField(0)
  final String department;

  ///说明
  @HiveField(1)
  final String? description;

  ///姓名
  @HiveField(2)
  final String? name;

  ///电话
  @HiveField(3)
  final String phone;

  ContactData(this.department, this.description, this.name, this.phone);

  factory ContactData.fromJson(Map<String, dynamic> json) => _$ContactDataFromJson(json);

  @override
  String toString() {
    return 'ContactData{department: $department, description: $description, name: $name, phone: $phone}';
  }
}
