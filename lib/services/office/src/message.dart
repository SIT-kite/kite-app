import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:kite/services/office/office.dart';

part 'message.g.dart';

const String serviceMessageCount = 'https://xgfy.sit.edu.cn/unifri-flow/user/queryFlowCount';

@JsonSerializable()
class OfficeMessageCount {
  @JsonKey(name: 'myFlow_complete_count')
  final int completed;
  @JsonKey(name: 'myFlow_runing_count')
  final int in_progress;
  @JsonKey(name: 'myFlow_todo_count')
  final int in_draft;

  const OfficeMessageCount(this.completed, this.in_progress, this.in_draft);

  factory OfficeMessageCount.fromJson(Map<String, dynamic> json) => _$OfficeMessageCountFromJson(json);
}

Future<OfficeMessageCount> queryMessageCount(OfficeSession session) async {
  String payload = 'code=${session.username}';

  final response = await session.dio.post(serviceMessageCount,
      data: payload,
      options: Options(headers: {
        'content-type': 'application/x-www-form-urlencoded',
      }));
  final Map<String, dynamic> data = response.data;
  final OfficeMessageCount result = OfficeMessageCount.fromJson(data);
  return result;
}
