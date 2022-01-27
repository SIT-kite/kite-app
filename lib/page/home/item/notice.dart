import 'package:flutter/material.dart';
import 'package:kite/entity/kite/notice.dart';
import 'package:kite/global/event_bus.dart';
import 'package:kite/global/session_pool.dart';
import 'package:kite/page/home/item.dart';
import 'package:kite/service/kite/index.dart';

class NoticeItem extends StatefulWidget {
  const NoticeItem({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _NoticeItemState();
}

class _NoticeItemState extends State<NoticeItem> {
  static const defaultContent = '查看小风筝上的公告';
  String content = '加载中';

  @override
  void initState() {
    eventBus.on(EventNameConstants.onHomeRefresh, _onHomeRefresh);
    super.initState();
  }

  @override
  void dispose() {
    eventBus.off(EventNameConstants.onHomeRefresh, _onHomeRefresh);
    super.dispose();
  }

  void _onHomeRefresh(_) async {
    final String result = await _buildContent() ?? defaultContent;
    setState(() => content = result);
  }

  Future<String?> _buildContent() async {
    try {
      final List<KiteNotice> list = await NoticeService(SessionPool.kiteSession).getNoticeList();
      return list.first.title;
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: _buildContent(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          content = snapshot.data ?? defaultContent;
        }
        return HomeItem(
          route: '/notice',
          icon: 'assets/home/icon_notice.svg',
          title: '公告',
          subtitle: content,
        );
      },
    );
  }
}
