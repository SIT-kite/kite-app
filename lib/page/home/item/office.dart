import 'package:flutter/material.dart';
import 'package:kite/global/event_bus.dart';
import 'package:kite/global/session_pool.dart';
import 'package:kite/global/storage_pool.dart';
import 'package:kite/page/home/item.dart';
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
