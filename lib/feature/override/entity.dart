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

  FunctionOverrideInfo();
  factory FunctionOverrideInfo.fromJson(Map<String, dynamic> json) => _$FunctionOverrideInfoFromJson(json);
  Map<String, dynamic> toJson() => _$FunctionOverrideInfoToJson(this);
}
