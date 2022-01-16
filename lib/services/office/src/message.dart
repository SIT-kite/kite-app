import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:json_annotation/json_annotation.dart';

import 'office_session.dart';

part 'message.g.dart';

const String serviceMessageCount = 'https://xgfy.sit.edu.cn/unifri-flow/user/queryFlowCount';

enum MessageType {
  todo,
  doing,
  done,
}

@JsonSerializable()
class OfficeMessageCount {
  @JsonKey(name: 'myFlow_complete_count')
  final int completed;
  @JsonKey(name: 'myFlow_runing_count')
  final int inProgress;
  @JsonKey(name: 'myFlow_todo_count')
  final int inDraft;

  const OfficeMessageCount(this.completed, this.inProgress, this.inDraft);

  factory OfficeMessageCount.fromJson(Map<String, dynamic> json) => _$OfficeMessageCountFromJson(json);
}

Future<OfficeMessageCount> queryMessageCount(OfficeSession session) async {
  String payload = 'code=${session.userName}';

  final response = await session.post(serviceMessageCount, data: payload, responseType: ResponseType.json);
  final Map<String, dynamic> data = response.data;
  final OfficeMessageCount result = OfficeMessageCount.fromJson(data);
  return result;
}

@JsonSerializable()
class OfficeMessageSummary {
  @JsonKey(name: 'WorkID')
  final int flowId;
  @JsonKey(name: 'FK_Flow')
  final String functionId;
  @JsonKey(name: 'FlowName')
  final String functionName;
  @JsonKey(name: 'NodeName')
  final String recentStep;
  @JsonKey(name: 'FlowNote')
  final String status;

  const OfficeMessageSummary(this.flowId, this.functionId, this.functionName, this.recentStep, this.status);

  factory OfficeMessageSummary.fromJson(Map<String, dynamic> json) => _$OfficeMessageSummaryFromJson(json);
}

class OfficeMessagePage {
  final int totalNum;
  final int totalPage;
  final int currentPage;
  final List<OfficeMessageSummary> msgList;

  const OfficeMessagePage(this.totalNum, this.totalPage, this.currentPage, this.msgList);
}

String _getMessageListUrl(MessageType type) {
  late String method;
  switch (type) {
    case MessageType.todo:
      method = 'Todolist_Init';
      break;
    case MessageType.doing:
      method = 'Runing_Init';
      break;
    case MessageType.done:
      method = 'Complete_Init';
      break;
  }
  return 'https://xgfy.sit.edu.cn/unifri-flow/WF/Comm/ProcessRequest.do?DoType=HttpHandler&DoMethod=$method&HttpHandlerName=BP.WF.HttpHandler.WF';
}

Future<OfficeMessagePage> getMessage(OfficeSession session, MessageType type, int page) async {
  final String url = _getMessageListUrl(type);
  final String payload = 'myFlow=1&pageIdx=$page&pageSize=999'; // TODO: 此处硬编码.

  final response = await session.post(url,
      data: payload, contentType: 'application/x-www-form-urlencoded', responseType: ResponseType.json);
  final List data = jsonDecode(response.data);
  final int totalNum = int.parse(data.last['totalNum']);
  final int totalPage = int.parse(data.last['totalPage']);
  final List<OfficeMessageSummary> messages =
      data.where((e) => (e['FlowName'] as String).isNotEmpty).map((e) => OfficeMessageSummary.fromJson(e)).toList();

  return OfficeMessagePage(totalNum, totalPage, page, messages);
}

Future<OfficeMessagePage> getAllMessage(OfficeSession session) async {
  List<OfficeMessageSummary> messageList = [];

  for (MessageType type in MessageType.values) {
    messageList.addAll((await getMessage(session, type, 1)).msgList);
  }
  // TODO: 此处硬编码.
  return OfficeMessagePage(messageList.length, 1, 1, messageList);
}
