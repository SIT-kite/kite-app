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

import 'package:kite/network/session.dart';

import '../dao/join.dart';

class ScJoinActivityService implements ScJoinActivityDao {
  static const _applyCheck = 'http://sc.sit.edu.cn/public/pcenter/check.action?activityId=';
  static const _applyRequest = 'http://sc.sit.edu.cn/public/pcenter/applyActivity.action?activityId=';

  static const _codeMessage = [
    '检查成功',
    '您的个人信息不全，请补全您的信息！',
    '您已申请过该活动，不能重复申请！',
    '对不起，您今天的申请次数已达上限！',
    '对不起，该活动的申请人数已达上限！',
    '对不起，该活动已过期并停止申请！',
    '您已申请过该时间段的活动，不能重复申请！',
    '对不起，您不能申请该活动！',
    '对不起，您不在该活动的范围内！',
  ];

  final Session session;

  const ScJoinActivityService(this.session);

  /// 提交最后的活动申请
  Future<String> _sendFinalRequest(int activityId) async {
    final url = _applyRequest + activityId.toString();
    return (await session.request(url, RequestMethod.get)).data;
  }

  Future<String> _sendCheckRequest(int activityId) async {
    final url = _applyCheck + activityId.toString();
    final code = ((await session.request(url, RequestMethod.get)).data as String).trim();

    return _codeMessage[int.parse(code)];
  }

  /// 参加活动
  @override
  Future<String> join(int activityId, [bool force = false]) async {
    if (!force) {
      final result = await _sendCheckRequest(activityId);
      if (result != '检查成功') {
        return result;
      }
    }
    return (await _sendFinalRequest(activityId)).contains('申请成功') ? '申请成功' : '申请失败';
  }
}
