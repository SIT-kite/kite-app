import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:kite/entity/bulletin.dart';
import 'package:kite/global/session_pool.dart';
import 'package:kite/service/bulletin.dart';
import 'package:kite/util/url_launcher.dart';

class DetailPage extends StatelessWidget {
  final BulletinRecord summary;

  const DetailPage(this.summary, {Key? key}) : super(key: key);

  Widget _buildArticleBody(BulletinRecord summary) {
    final service = BulletinService(SessionPool.ssoSession);
    final future = service.getBulletinDetail(summary.bulletinCatalogueId, summary.uuid);

    return FutureBuilder<BulletinDetail>(
        future: future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              final detail = snapshot.data!.content;

              return SingleChildScrollView(
                child: HtmlWidget(detail, onTapUrl: (url) {
                  launchInBrowser(url);
                  return true;
                }),
              );
            } else if (snapshot.hasError) {
              return Text(snapshot.error.runtimeType.toString());
            }
          }
          return const Center(child: CircularProgressIndicator());
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('公告正文')),
      body: Padding(padding: const EdgeInsets.all(12), child: _buildArticleBody(summary)),
    );
  }
}
