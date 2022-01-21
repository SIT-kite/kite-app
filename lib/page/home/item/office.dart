import 'package:flutter/material.dart';
import 'package:kite/global/bus.dart';
import 'package:kite/global/session_pool.dart';
import 'package:kite/global/storage_pool.dart';
import 'package:kite/page/home/item.dart';
import 'package:kite/service/office.dart';

class OfficeItem extends StatefulWidget {
  const OfficeItem({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _OfficeItemState();
}

class _OfficeItemState extends State<OfficeItem> {
  String content = '默认文字'; // TODO: 此处使用默认值.

  @override
  void initState() {
    eventBus.on('onHomeRefresh', _onHomeRefresh);
    return super.initState();
  }

  @override
  void dispose() {
    eventBus.off('onHomeRefresh', _onHomeRefresh);
    super.dispose();
  }

  void _onHomeRefresh(_) async {
    final String result = await _buildContent();
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
    return HomeItem(route: '/office', icon: 'assets/home/icon_office.svg', title: '办公', subtitle: content);
  }
}
