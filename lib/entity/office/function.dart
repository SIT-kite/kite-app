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
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:kite/util/iconfont.dart';

part 'function.g.dart';

@JsonSerializable(createToJson: false)
class SimpleFunction {
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

  const SimpleFunction(this.id, this.name, this.summary, this.status, this.count, this.icon);

  factory SimpleFunction.fromJson(Map<String, dynamic> json) => _$SimpleFunctionFromJson(json);
}

@JsonSerializable()
class FunctionDetailSection {
  @JsonKey(name: 'formName')
  final String section;
  final String type;
  final DateTime createTime;
  final String content;

  const FunctionDetailSection(this.section, this.type, this.createTime, this.content);

  factory FunctionDetailSection.fromJson(Map<String, dynamic> json) => _$FunctionDetailSectionFromJson(json);
}
