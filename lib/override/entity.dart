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

part 'entity.g.dart';

@JsonSerializable()
class RouteOverrideItem {
  // 要拦截的路由
  String inputRoute = '';
  // 被替换的路由
  String outputRoute = '';
  // 被替换的路由参数
  Map<String, dynamic> args = {};
  RouteOverrideItem();

  factory RouteOverrideItem.fromJson(Map<String, dynamic> json) => _$RouteOverrideItemFromJson(json);
  Map<String, dynamic> toJson() => _$RouteOverrideItemToJson(this);
}

@JsonSerializable()
class ExtraHomeItem {
  String title = '';
  String route = '';
  @JsonKey(defaultValue: '')
  String description = '';
  String iconUrl = '';
  ExtraHomeItem();
  factory ExtraHomeItem.fromJson(Map<String, dynamic> json) => _$ExtraHomeItemFromJson(json);
  Map<String, dynamic> toJson() => _$ExtraHomeItemToJson(this);
}

@JsonSerializable()
class HomeItemHideInfo {
  @JsonKey(defaultValue: [])
  List<String> nameList = [];

  @JsonKey(defaultValue: [])
  List<String> userTypeList = [];

  HomeItemHideInfo();
  factory HomeItemHideInfo.fromJson(Map<String, dynamic> json) => _$HomeItemHideInfoFromJson(json);
  Map<String, dynamic> toJson() => _$HomeItemHideInfoToJson(this);
}

@JsonSerializable()
class RouteNotice {
  int id = 0;
  String title = '';
  String msg = '';
  RouteNotice();
  factory RouteNotice.fromJson(Map<String, dynamic> json) => _$RouteNoticeFromJson(json);
  Map<String, dynamic> toJson() => _$RouteNoticeToJson(this);
}

@JsonSerializable()
class FunctionOverrideInfo {
  @JsonKey(defaultValue: [])
  List<RouteOverrideItem> routeOverride = [];

  @JsonKey(defaultValue: [])
  List<ExtraHomeItem> extraHomeItem = [];

  @JsonKey(defaultValue: [])
  List<HomeItemHideInfo> homeItemHide = [];

  @JsonKey(defaultValue: {})
  Map<String, RouteNotice> routeNotice = {};

  /// 色彩饱和度，设置为0则全黑白，设置为1为全彩色
  @JsonKey(defaultValue: 1)
  double homeColorSaturation = 1;

  FunctionOverrideInfo();
  factory FunctionOverrideInfo.fromJson(Map<String, dynamic> json) => _$FunctionOverrideInfoFromJson(json);
  Map<String, dynamic> toJson() => _$FunctionOverrideInfoToJson(this);
}
