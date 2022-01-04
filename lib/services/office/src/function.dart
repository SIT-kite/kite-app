import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:kite/services/office/office.dart';
import 'package:kite/services/office/src/signature.dart';
import 'package:kite/utils/iconfont.dart';

part 'function.g.dart';

const String serviceFunctionList = 'https://xgfy.sit.edu.cn/app/public/queryAppManageJson';
const String serviceFunctionDetail = 'https://xgfy.sit.edu.cn/app/public/queryAppFormJson';

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

Future<List<SimpleFunction>> selectFunctions(OfficeSession session) async {
  String payload = '{"appObject":"student","appName":null}';

  final String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
  final Response response = await session.dio.post(serviceFunctionList,
      data: payload,
      options: Options(headers: {
        'content-type': 'application/json',
        'Authorization': session.jwtToken,
        'timestamp': timestamp,
        'signature': sign(timestamp),
      }));

  final Map<String, dynamic> data = response.data;
  final List<SimpleFunction> functionList = (data['value'] as List<dynamic>)
      .map((e) => SimpleFunction.fromJson(e))
      .where((element) => element.status == 1) // Filter functions unavailable.
      .toList();

  return functionList;
}

Future<List<SimpleFunction>> selectFunctionsByCountDesc(OfficeSession session) async {
  final functions = await selectFunctions(session);
  functions.sort((a, b) => a.count.compareTo(b.count));
  return functions;
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

class FunctionDetail {
  final String id;
  final List<FunctionDetailSection> sections;

  const FunctionDetail(this.id, this.sections);
}

Future<FunctionDetail> getFunctionDetail(OfficeSession session, String functionId) async {
  final String payload = '{"appID":"$functionId"}';

  final String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
  final response = await session.dio.post(serviceFunctionDetail,
      data: payload,
      options: Options(headers: {
        'content-type': 'application/json',
        'authorization': session.jwtToken,
        'timestamp': timestamp,
        'signature': sign(timestamp),
      }));
  final Map<String, dynamic> data = jsonDecode(response.data);
  final List<FunctionDetailSection> sections =
      (data['value'] as List<dynamic>).map((e) => FunctionDetailSection.fromJson(e)).toList();

  return FunctionDetail(functionId, sections);
}
