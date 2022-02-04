import 'package:flutter/material.dart';
import 'package:kite/entity/bulletin.dart';
import 'package:kite/global/session_pool.dart';
import 'package:kite/service/bulletin.dart';

import './detail.dart';

class BulletinPage extends StatelessWidget {
  const BulletinPage({Key? key}) : super(key: key);

  Widget _buildBulletinList() {
    final service = BulletinService(SessionPool.ssoSession);
    final future = service.queryBulletinListInAllCategory(1);

    return FutureBuilder<List<BulletinRecord>>(
        future: future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              final records = snapshot.data!;
              BulletinService.sortBulletinRecord(records);

              final items = records
                  .map((e) => ListTile(
                        title: Text(e.title),
                        subtitle: Text(e.department + ' | ' + e.dateTime.toString()),
                        onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => DetailPage(e))),
                      ))
                  .toList();
              return SingleChildScrollView(
                  child: Column(
                children: items,
              ));
            } else if (snapshot.hasError) {
              return Center(child: Text('错误类型: ' + snapshot.error.runtimeType.toString()));
            }
          }
          return const Center(child: CircularProgressIndicator());
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('OA 公告'),
      ),
      body: _buildBulletinList(),
    );
  }
}
