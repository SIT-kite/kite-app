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
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:kite/abstract/abstract_service.dart';
import 'package:kite/abstract/abstract_session.dart';
import 'package:kite/storage/init.dart';

import '../entity/index.dart';

const String serviceMessageCount = 'https://xgfy.sit.edu.cn/unifri-flow/user/queryFlowCount';

class OfficeMessageService extends AService {
  OfficeMessageService(ASession session) : super(session);

  Future<OfficeMessageCount> queryMessageCount() async {
    String payload = 'code=${KvStorageInitializer.auth.currentUsername}';

    final response = await session.post(serviceMessageCount,
        data: payload, contentType: Headers.formUrlEncodedContentType, responseType: ResponseType.json);
    final Map<String, dynamic> data = response.data;
    final OfficeMessageCount result = OfficeMessageCount.fromJson(data['data']);
    return result;
  }

  Future<OfficeMessagePage> getMessage(MessageType type, int page) async {
    final String url = _getMessageListUrl(type);
    final String payload = 'myFlow=1&pageIdx=$page&pageSize=999'; // TODO: 此处硬编码.

    final response = await session.post(
      url,
      data: payload,
      contentType: 'application/x-www-form-urlencoded',
      responseType: ResponseType.json,
    );
    final List data = jsonDecode(response.data);
    final int totalNum = int.parse(data.last['totalNum']);
    final int totalPage = int.parse(data.last['totalPage']);
    final List<OfficeMessageSummary> messages =
        data.where((e) => (e['FlowName'] as String).isNotEmpty).map((e) => OfficeMessageSummary.fromJson(e)).toList();

    return OfficeMessagePage(totalNum, totalPage, page, messages);
  }

  Future<OfficeMessagePage> getAllMessage() async {
    List<OfficeMessageSummary> messageList = [];

    for (MessageType type in MessageType.values) {
      messageList.addAll((await getMessage(type, 1)).msgList);
    }
    // TODO: 此处硬编码.
    return OfficeMessagePage(messageList.length, 1, 1, messageList);
  }

  static String _getMessageListUrl(MessageType type) {
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
}
