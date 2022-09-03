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
import 'dart:io';

import 'package:catcher/catcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kite/feature/edu/timetable/cache.dart';
import 'package:kite/feature/edu/timetable/init.dart';
import 'package:kite/feature/edu/timetable/page/component/daily_and_weekly.dart';
import 'package:kite/route.dart';
import 'package:kite/util/alert_dialog.dart';
import 'package:kite/util/flash.dart';
import 'package:kite/util/logger.dart';
import 'package:kite/util/url_launcher.dart';

import '../entity.dart';
import '../util.dart';

class TimetablePage extends StatefulWidget {
  const TimetablePage({Key? key}) : super(key: key);

  @override
  State<TimetablePage> createState() => _TimetablePageState();
}

class _TimetablePageState extends State<TimetablePage> {
  /// 最大周数
  /// TODO 还没用上
  // static const int maxWeekCount = 20;
  final tableViewerController = TimetableViewerController();

  final storage = TimetableInitializer.timetableStorage;

  // 模式：周课表 日课表
  late DisplayMode displayMode;

  // 课程表
  late List<Course> courses;

  // 课表元数据
  late TimetableMeta? meta;

  @override
  void initState() {
    Log.info('Timetable init');
    displayMode = storage.lastMode ?? DisplayMode.daily;
    storage.lastMode = displayMode;

    courses = storage.currentTableCourses ?? [];
    meta = storage.currentTableMeta;

    if (courses.isEmpty) {
      Future.delayed(Duration.zero, () async {
        final select = await showAlertDialog(
          context,
          title: '导入课表',
          content: [
            const Text(
              '您似乎是第一次使用小风筝课表，请先完成课表导入吧！',
            ),
          ],
          actionWidgetList: [
            ElevatedButton(onPressed: () {}, child: const Text('导入课表')),
            TextButton(onPressed: () {}, child: const Text('暂时不想')),
          ],
        );
        if (select == 0) {
          await Navigator.of(context).pushNamed(RouteTable.timetableImport);
          _onRefresh();
        }
      });
    }
    super.initState();
  }

  void _exportByUrl() async {
    final url = 'http://localhost:8081/${getExportTimetableFilename()}';
    HttpServer? server;
    try {
      server = await HttpServer.bind(InternetAddress.loopbackIPv4, 8081, shared: true);

      Log.info('HTTP服务启动成功');
      server.listen((HttpRequest request) {
        request.response.headers.contentType = ContentType.parse('text/calendar');
        request.response.write(convertTableToIcs(meta!, courses));
        request.response.close();
      });

      if (!mounted) return;

      await showAlertDialog(
        context,
        title: '已生成链接',
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextButton(
              onPressed: () => launchUrlInBrowser(url),
              child: Text(url),
            ),
            TextButton(
              onPressed: () async {
                await Clipboard.setData(ClipboardData(text: url));
                EasyLoading.showSuccess('成功复制到剪切板');
              },
              child: const Text('点击此处可复制链接'),
            ),
            const Text('注意：关闭本对话框后链接将失效'),
          ],
        ),
        actionTextList: ['关闭'],
      );
    } catch (e, st) {
      Log.info('HTTP服务启动失败');
      Catcher.reportCheckedError(e, st);
      return;
    } finally {
      server?.close();
      Log.info('HTTP服务已关闭');
    }
  }

  void _onExport() {
    if (courses.isEmpty) {
      showBasicFlash(context, const Text('你咋没课呢？？'));
      return;
    }
    showAlertDialog(context,
        title: '请选择导出方式',
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              onPressed: () => exportTimetableToCalendar(meta!, courses),
              child: const Text('导出至文件'),
            ),
            SizedBox(height: 10.h),
            ElevatedButton(
              onPressed: _exportByUrl,
              child: const Text('导出为URL'),
            ),
          ],
        ),
        actionWidgetList: [TextButton(onPressed: () {}, child: const Text('关闭对话框'))]);
  }

  /// 根据本地缓存刷新课表
  void _onRefresh() {
    setState(() {
      courses = storage.currentTableCourses ?? [];
      meta = storage.currentTableMeta;
    });
    showBasicFlash(context, const Text('加载成功'));
  }

  ///更多菜单回调方法
  PopupMenuButton _buildPopupMenu(BuildContext context) {
    final List<Function()> callback = [
      () => Navigator.of(context).pushNamed(RouteTable.timetableImport).then((value) => _onRefresh()),
      _onRefresh,
      _onExport,
    ];

    ///更多菜单按钮
    return PopupMenuButton(
      onSelected: (index) => callback[index](),
      itemBuilder: (BuildContext ctx) {
        return const <PopupMenuEntry>[
          PopupMenuItem(value: 0, child: Text('导入课表')),
          PopupMenuItem(value: 1, child: Text('刷新')),
          PopupMenuItem(value: 2, child: Text('导出日历')),
        ];
      },
    );
  }

  ///切换按钮
  Widget _buildModeSwitchButton() {
    return IconButton(
      icon: const Icon(Icons.swap_horiz),
      onPressed: tableViewerController.switchDisplayMode,
    );
  }

  @override
  Widget build(BuildContext context) {
    Log.info('Timetable build');
    return Scaffold(
      appBar: AppBar(
        title: const Text('课程表'),
        actions: <Widget>[
          _buildModeSwitchButton(),
          _buildPopupMenu(context),
        ],
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () => tableViewerController.jumpToToday(),
          child: Text('今', style: Theme.of(context).textTheme.headline2?.copyWith(color: Colors.white))),
      body: TimetableViewer(
        key: UniqueKey(),
        controller: tableViewerController,
        initialTableMeta: meta,
        initialTableCourses: courses,
        tableCache: TableCache(),
        initialDisplayMode: displayMode,
        onDisplayChanged: (DisplayMode displayMode) {
          storage.lastMode = displayMode;
        },
      ),
    );
  }
}
