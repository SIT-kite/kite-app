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
import 'package:intl/intl.dart';
import 'package:kite/component/html_widget.dart';
import 'package:kite/entity/bulletin.dart';
import 'package:kite/global/session_pool.dart';
import 'package:kite/service/bulletin.dart';
import 'package:kite/util/flash.dart';
import 'package:kite/util/url_launcher.dart';

class DetailPage extends StatelessWidget {
  static final RegExp _phoneRegex = RegExp(r"(6087\d{4})");
  static final RegExp _mobileRegex = RegExp(r"(\d{12})");
  static final dateFormat = DateFormat('yyyy/MM/dd HH:mm');

  final BulletinRecord summary;

  const DetailPage(this.summary, {Key? key}) : super(key: key);

  String _linkTel(String content) {
    String t = content;
    for (var phone in _phoneRegex.allMatches(t)) {
      final num = phone.group(0).toString();
      t = t.replaceAll(num, '<a href="tel://021$num">$num</a>');
    }
    for (var mobile in _mobileRegex.allMatches(content)) {
      final num = mobile.group(0).toString();
      t = t.replaceAll(num, '<a href="tel://$num">$num</a>');
    }
    return t;
  }

  Widget _buildArticle(BuildContext context, BulletinDetail article) {
    final titleStyle = Theme.of(context).textTheme.headline2?.copyWith(fontWeight: FontWeight.bold);
    final subtitleStyle = Theme.of(context).textTheme.headline4?.copyWith(color: Colors.black54);

    return Column(
      children: <Widget>[
        Text(article.title, style: titleStyle),
        Text('${article.department} | ${article.author}  ${dateFormat.format(article.dateTime)}', style: subtitleStyle),
        MyHtmlWidget(_linkTel(article.content)),
        const SizedBox(height: 30),
        Column(
          children: article.attachments.map((e) {
            return TextButton(
              onPressed: () async {
                showBasicFlash(context, const Text('请在开启的浏览器中登录将直接开始下载'));
                await Future.delayed(const Duration(seconds: 1));
                //TODO: 未来需要写个下载管理器
                launchInBrowser(e.url);
              },
              child: Text(e.name),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildBody(BulletinRecord summary) {
    final service = BulletinService(SessionPool.ssoSession);
    final future = service.getBulletinDetail(summary.bulletinCatalogueId, summary.uuid);

    return FutureBuilder<BulletinDetail>(
        future: future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              return SingleChildScrollView(child: _buildArticle(context, snapshot.data!));
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
      appBar: AppBar(
        title: const Text('公告正文'),
        actions: [
          IconButton(
            onPressed: () {
              final url =
                  'https://myportal.sit.edu.cn/detach.portal?action=bulletinBrowser&.ia=false&.pmn=view&.pen=${summary.bulletinCatalogueId}&bulletinId=${summary.uuid}';
              launchInBrowser(url);
            },
            icon: const Icon(Icons.open_in_browser),
          ),
        ],
      ),
      body: Padding(padding: const EdgeInsets.all(12), child: _buildBody(summary)),
    );
  }
}
