import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:kite/entity/kite/user_event.dart';
import 'package:kite/global/session_pool.dart';
import 'package:kite/global/storage_pool.dart';

const String reportEventUrl = "https://kite.sunnysab.cn/api/v2/report/event";
const int maxCacheSize = 10;

class PageLogger {
  var cachedCount = StoragePool.userEvent.getEventCount();
  final Dio _dio = SessionPool.dio;
  final storage = StoragePool.userEvent;

  void _postReport(List<UserEvent> eventList) {
    // _portReport 不能阻塞, 故使用异步方法.
    Future.delayed(Duration.zero, () async {
      try {
        _dio.post(reportEventUrl, data: jsonEncode(eventList), options: Options(sendTimeout: 10 * 1000));
      } catch (_) {
        // 由于网络原因上报失败, 再把日志加回存储区
        storage.appendAll(eventList);
        cachedCount += maxCacheSize;
      }
    });
  }

  void _uploadReport() {
    if (cachedCount <= maxCacheSize) {
      return;
    }
    final tmp = storage.getEvents();
    storage.clear();
    cachedCount = 0;
    _postReport(tmp);
  }

  void log(UserEventType type, [Map<String, String> params = const {}]) {
    final event = UserEvent(type, params);
    storage.append(event);

    _uploadReport();
  }

  void page(String route, [String? param]) {
    var params = {'page': route};
    if (param != null) {
      params.addAll({'param': param});
    }
    log(UserEventType.page, params);
    cachedCount++;
  }

  void startup() {
    log(UserEventType.startup);
  }

  void exit() {
    log(UserEventType.exit);
  }
}

final pageLogger = PageLogger();
