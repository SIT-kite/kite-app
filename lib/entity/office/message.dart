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
