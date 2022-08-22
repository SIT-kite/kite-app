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
import 'package:flutter/material.dart';
import 'package:kite/feature/initializer_index.dart';
import 'package:kite/feature/report/entity/report.dart';
import 'package:kite/global/global.dart';
import 'package:kite/storage/init.dart';

import 'index.dart';

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
    Global.eventBus.on(EventNameConstants.onHomeRefresh, _onHomeRefresh);

    return super.initState();
  }

  @override
  void dispose() {
    Global.eventBus.off(EventNameConstants.onHomeRefresh, _onHomeRefresh);
    super.dispose();
  }

  void _onHomeRefresh(_) async {
    final String result = await _buildContent();
    if (!mounted) return;
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
    late ReportHistory? history;

    try {
      history = await ReportInitializer.reportService.getRecentHistory(KvStorageInitializer.auth.currentUsername ?? '');
    } catch (e) {
      return '获取状态失败, ${e.runtimeType}';
    }
    if (history == null) {
      return '无上报记录';
    }
    // 别忘了本地缓存更新一下.
    KvStorageInitializer.home.lastReport = history;
    return _generateContent(history);
  }

  @override
  Widget build(BuildContext context) {
    // 如果是第一次加载 (非下拉导致的渲染), 加载缓存的上报记录.
    if (content == null) {
      final ReportHistory? lastReport = KvStorageInitializer.home.lastReport;
      // 如果本地没有缓存记录, 加载默认文本. 否则加载记录.
      if (lastReport == null) {
        content = defaultContent;
      } else {
        content = _generateContent(lastReport);
      }
    }
    return HomeFunctionButton(route: '/report', icon: 'assets/home/icon_report.svg', title: '体温上报', subtitle: content);
  }
}
