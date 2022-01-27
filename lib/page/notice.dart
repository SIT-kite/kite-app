import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kite/entity/kite/notice.dart';
import 'package:kite/global/session_pool.dart';
import 'package:kite/service/kite/index.dart';

class NoticePage extends StatelessWidget {
  const NoticePage({Key? key}) : super(key: key);

  Widget _buildNoticeItem(KiteNotice notice) {
    final dateFormat = DateFormat('yyyy / MM / dd');

    return Card(
      margin: const EdgeInsets.fromLTRB(10, 10, 10, 0),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // 标题, 注意遇到长标题时要折断
                Expanded(
                  flex: 3,
                  child: Text((notice.top ? '[置顶] ' : '') + notice.title,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ),
                // 日期
                Expanded(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(minWidth: 90),
                    child: Text(dateFormat.format(notice.publishTime), style: const TextStyle(color: Colors.grey)),
                  ),
                )
              ],
            ),
            const SizedBox(height: 10),
            // 正文
            Text(notice.content ?? notice.title)
          ],
        ),
      ),
    );
  }

  Widget _buildNoticeList(List<KiteNotice> noticeList) {
    return SingleChildScrollView(
      child: Column(
        children: noticeList.map(_buildNoticeItem).toList(),
      ),
    );
  }

  Widget _buildBody() {
    final future = NoticeService(SessionPool.kiteSession).getNoticeList();

    return FutureBuilder<List<KiteNotice>>(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData) {
            return _buildNoticeList(snapshot.data!);
          } else if (snapshot.hasError) {
            return Center(child: Text('加载失败: ${snapshot.error.runtimeType.toString()}'));
          }
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('公告')),
      body: SafeArea(child: _buildBody()),
    );
  }
}
