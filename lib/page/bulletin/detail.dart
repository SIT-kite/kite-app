/*
 *    上应小风筝(SIT-kite)  便利校园，一步到位
 *    Copyright (C) 2022 上海应用技术大学 上应小风筝团队
 *
 *    This program is free software: you can redistribute it and/or modify
 *    it under the terms of the GNU General Public License as published by
 *    the Free Software Foundation, either version 3 of the License, or
 *    (at your option) any later version.
 *
 *    This program is distributed in the hope that it will be useful,
 *    but WITHOUT ANY WARRANTY; without even the implied warranty of
 *    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *    GNU General Public License for more details.
 *
 *    You should have received a copy of the GNU General Public License
 *    along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/
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
