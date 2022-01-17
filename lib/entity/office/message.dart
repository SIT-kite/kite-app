import 'package:json_annotation/json_annotation.dart';

part 'message.g.dart';

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
