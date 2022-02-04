/*
 *    上应小风筝(SIT-kite)  便利校园，一步到位
 *    Copyright (C) 2022 上海应用技术大学 上应小风筝团队
 *
 *    This program is free software: you can redistribute it and/or modify
 *    it under the terms of the GNU General Public License as published by
 *    the Free Software Foundation, either version 3 of the License, or
 *    (at your option) any later version.
 *
 *    This program is distributed in the hope that it will be useful,
 *    but WITHOUT ANY WARRANTY; without even the implied warranty of
 *    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *    GNU General Public License for more details.
 *
 *    You should have received a copy of the GNU General Public License
 *    along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/
import 'package:flutter/material.dart';
import 'package:kite/global/event_bus.dart';
import 'package:kite/global/session_pool.dart';
import 'package:kite/global/storage_pool.dart';
import 'package:kite/page/home/item/item.dart';
import 'package:kite/service/office/index.dart';

class OfficeItem extends StatefulWidget {
  const OfficeItem({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _OfficeItemState();
}

class _OfficeItemState extends State<OfficeItem> {
  static const defaultContent = '通过应网办办理业务';
  String? content;

  @override
  void initState() {
    eventBus.on(EventNameConstants.onHomeRefresh, _onHomeRefresh);
    return super.initState();
  }

  @override
  void dispose() {
    eventBus.off(EventNameConstants.onHomeRefresh, _onHomeRefresh);
    super.dispose();
  }

  void _onHomeRefresh(_) async {
    final String result = await _buildContent();
    StoragePool.homeSetting.lastOfficeStatus = result;
    setState(() => content = result);
  }

  Future<String> _buildContent() async {
    final username = StoragePool.authSetting.currentUsername!;
    final password = StoragePool.authPool.get(username)!.password;

    if (SessionPool.officeSession == null) {
      try {
        SessionPool.officeSession = await officeLogin(username, password);
      } on OfficeLoginException catch (e) {
        return e.msg;
      } catch (e) {
        return e.runtimeType.toString();
      }
    }
    format(s, x) => x > 0 ? '$s ($x)' : '';
    final totalMessage = await queryMessageCount(SessionPool.officeSession!);
    final draftBlock = format('草稿', totalMessage.inDraft);
    final doingBlock = format('在办', totalMessage.inProgress);
    final completedBlock = format('完成', totalMessage.completed);

    return '$draftBlock $doingBlock $completedBlock'.trim();
  }

  @override
  Widget build(BuildContext context) {
    // 如果是首屏加载, 从缓存读
    if (content == null) {
      final String? lastOfficeStatus = StoragePool.homeSetting.lastOfficeStatus;
      content = lastOfficeStatus ?? defaultContent;
    }
    return HomeItem(route: '/office', icon: 'assets/home/icon_office.svg', title: '办公', subtitle: content);
  }
}
