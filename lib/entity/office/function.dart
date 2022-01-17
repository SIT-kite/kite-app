import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:kite/utils/iconfont.dart';

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
