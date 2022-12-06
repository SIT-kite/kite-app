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
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

import '../using.dart';

part 'application.g.dart';

@JsonSerializable(createToJson: false)
class ApplicationMeta {
  @JsonKey(name: 'appID')
  final String id;
  @JsonKey(name: 'appName')
  final String name;
  @JsonKey(name: 'appDescribe')
  final String summary;
  @JsonKey(name: 'appStatus')
  final int status;
  @JsonKey(name: 'appCount')
  final int count;
  @JsonKey(name: 'appIcon', fromJson: IconFont.query)
  final IconData icon;

  const ApplicationMeta(this.id, this.name, this.summary, this.status, this.count, this.icon);

  factory ApplicationMeta.fromJson(Map<String, dynamic> json) => _$ApplicationMetaFromJson(json);
}

@JsonSerializable()
class ApplicationDetailSection {
  @JsonKey(name: 'formName')
  final String section;
  final String type;
  final DateTime createTime;
  final String content;

  const ApplicationDetailSection(this.section, this.type, this.createTime, this.content);

  factory ApplicationDetailSection.fromJson(Map<String, dynamic> json) => _$ApplicationDetailSectionFromJson(json);
}

class ApplicationDetail {
  final String id;
  final List<ApplicationDetailSection> sections;

  const ApplicationDetail(this.id, this.sections);
}
