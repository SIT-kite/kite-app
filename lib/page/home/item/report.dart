import 'package:flutter/material.dart';
import 'package:kite/entity/report.dart';
import 'package:kite/global/bus.dart';
import 'package:kite/global/session_pool.dart';
import 'package:kite/global/storage_pool.dart';
import 'package:kite/page/home/item.dart';
import 'package:kite/service/report.dart';

class ReportItem extends StatefulWidget {
  const ReportItem({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ReportItemState();
}

class _ReportItemState extends State<ReportItem> {
  String content = '默认文字';

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
    late ReportHistory? history;

    SessionPool.reportSession ??= ReportSession(username, dio: SessionPool.dio);
    try {
      history = await ReportService(SessionPool.reportSession!).getRecentHistory(username);
    } catch (e) {
      return '获取状态失败, ${e.runtimeType}';
    }
    if (history == null) {
      return '无上报记录';
    }
    final today = DateTime.now();
    if (history.date != (today.year * 10000 + today.month * 100 + today.day)) {
      return '今日未上报';
    }
    final normal = history.isNormal == 0 ? '体温正常' : '体温异常';
    return '今日已上报, $normal (${history.place})';
  }

  @override
  Widget build(BuildContext context) {
    return HomeItem(route: '/report', icon: 'assets/home/icon_report.svg', title: '体温上报', subtitle: content);
  }
}
