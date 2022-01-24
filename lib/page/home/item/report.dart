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
  static const String defaultContent = '记得上报哦';
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
    setState(() => content = result);
  }

  String _generateContent(ReportHistory history) {
    final today = DateTime.now();
    if (history.date != (today.year * 10000 + today.month * 100 + today.day)) {
      return '今日未上报';
    }
    final normal = history.isNormal == 0 ? '体温正常' : '体温异常';
    return '今日已上报, $normal (${history.place})';
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
    // 别忘了本地缓存更新一下.
    StoragePool.homeSetting.lastReport = history;
    return _generateContent(history);
  }

  @override
  Widget build(BuildContext context) {
    // 如果是第一次加载 (非下拉导致的渲染), 加载缓存的上报记录.
    if (content == null) {
      final ReportHistory? lastReport = StoragePool.homeSetting.lastReport;
      // 如果本地没有缓存记录, 加载默认文本. 否则加载记录.
      if (lastReport == null) {
        content = defaultContent;
      } else {
        content = _generateContent(lastReport);
      }
    }
    return HomeItem(route: '/report', icon: 'assets/home/icon_report.svg', title: '体温上报', subtitle: content);
  }
}
