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

import '../dao/message.dart';
import '../using.dart';

import '../entity/message.dart';

const String serviceMessageCount = 'https://xgfy.sit.edu.cn/unifri-flow/user/queryFlowCount';

class ApplicationMessageService implements ApplicationMessageDao {
  final ISession session;

  const ApplicationMessageService(this.session);

  @override
  Future<ApplicationMsgCount> getMessageCount() async {
    final account = Auth.oaCredential!.account;
    String payload = 'code=$account';

    final response = await session.request(
      serviceMessageCount,
      ReqMethod.post,
      data: payload,
      options: SessionOptions(
        contentType: 'application/x-www-form-urlencoded;charset=utf-8',
        responseType: SessionResType.json,
      ),
    );
    final Map<String, dynamic> data = response.data;
    final ApplicationMsgCount result = ApplicationMsgCount.fromJson(data['data']);
    return result;
  }

  Future<ApplicationMsgPage> getMessage(MessageType type, int page) async {
    final String url = _getMessageListUrl(type);
    final String payload = 'myFlow=1&pageIdx=$page&pageSize=999'; // TODO: 此处硬编码.

    final response = await session.request(
      url,
      ReqMethod.post,
      data: payload,
      options: SessionOptions(
        contentType: 'application/x-www-form-urlencoded',
        responseType: SessionResType.json,
      ),
    );
    final List data = jsonDecode(response.data);
    final int totalNum = int.parse(data.last['totalNum']);
    final int totalPage = int.parse(data.last['totalPage']);
    final List<ApplicationMsg> messages =
        data.where((e) => (e['FlowName'] as String).isNotEmpty).map((e) => ApplicationMsg.fromJson(e)).toList();

    return ApplicationMsgPage(totalNum, totalPage, page, messages);
  }

  @override
  Future<ApplicationMsgPage> getAllMessage() async {
    List<ApplicationMsg> messageList = [];

    for (MessageType type in MessageType.values) {
      messageList.addAll((await getMessage(type, 1)).msgList);
    }
    // TODO: 此处硬编码.
    return ApplicationMsgPage(messageList.length, 1, 1, messageList);
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
