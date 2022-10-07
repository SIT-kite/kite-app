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

import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

import '../entity/announcement.dart';
import '../entity/attachment.dart';
import '../using.dart';
import '../init.dart';

class DetailPage extends StatefulWidget {
  final BulletinRecord summary;

  const DetailPage(this.summary, {Key? key}) : super(key: key);

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  static final RegExp _phoneRegex = RegExp(r"(6087\d{4})");
  static final RegExp _mobileRegex = RegExp(r"(\d{12})");

  // static final dateFormat = DateFormat('yyyy/MM/dd HH:mm');

  String _linkTel(String content) {
    String t = content;
    for (var phone in _phoneRegex.allMatches(t)) {
      final num = phone.group(0).toString();
      t = t.replaceAll(num, '<a href="tel:021$num">$num</a>');
    }
    for (var mobile in _mobileRegex.allMatches(content)) {
      final num = mobile.group(0).toString();
      t = t.replaceAll(num, '<a href="tel:$num">$num</a>');
    }
    return t;
  }

  Future<void> _onDownloadFile(Attachment attachment) async {
    showBasicFlash(context, i18n.downloading.txt, duration: const Duration(seconds: 1));
    Log.info('下载文件: [${attachment.name}](${attachment.url})');

    String targetPath = '${(await getTemporaryDirectory()).path}/kite1/downloads/${attachment.name}';
    Log.info('下载到：$targetPath');
    // 如果文件不存在，那么下载文件
    if (!await File(targetPath).exists()) {
      await OaAnnouncementInit.session.download(
        attachment.url,
        savePath: targetPath,
        onReceiveProgress: (int count, int total) {
          // Log.info('已下载: ${count / (1024 * 1024)}MB');
        },
      );
    }

    if (!mounted) return;
    showBasicFlash(
      context,
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                i18n.downloadCompleted.txt,
                Text(attachment.name),
              ],
            ),
          ),
          TextButton(
            onPressed: () => OpenFile.open(targetPath),
            child: i18n.open.txt,
          ),
        ],
      ),
      duration: const Duration(seconds: 5),
    );
  }

  Widget _buildCard(BuildContext context, BulletinDetail article) {
    final valueStyle = Theme.of(context).textTheme.bodyText2;
    final keyStyle = valueStyle?.copyWith(fontWeight: FontWeight.bold);

    TableRow buildRow(String key, String value) => TableRow(
          children: [
            Text(key, style: keyStyle),
            Text(value, style: valueStyle),
          ],
        );

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 2),
      child: Padding(
          padding: const EdgeInsets.all(10),
          child: Table(
            columnWidths: const {
              0: FlexColumnWidth(1),
              1: FlexColumnWidth(3),
            },
            children: [
              buildRow(i18n.publishingDepartment, article.department),
              buildRow(i18n.author, article.author),
              buildRow(i18n.publishTime, context.dateText(article.dateTime)),
            ],
          )),
    );
  }

  Widget _buildArticle(BuildContext context, BulletinDetail article) {
    final titleStyle = Theme.of(context).textTheme.headline2;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(article.title, style: titleStyle),
        _buildCard(context, article),
        const SizedBox(height: 30),
        MyHtmlWidget(_linkTel(article.content)),
        const SizedBox(height: 30),
        if (article.attachments.isNotEmpty)
          Text(i18n.oaAnnouncementAttachmentTip(article.attachments.length), style: titleStyle),
        if (article.attachments.isNotEmpty)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: article.attachments.map((e) {
              return TextButton(
                onPressed: () async => _onDownloadFile(e),
                child: Text(e.name),
              );
            }).toList(),
          ),
      ],
    );
  }

  BulletinDetail? article;

  Future<BulletinDetail> getBulletinDetail() async {
    if (article == null) {
      Log.info('开始加载OA公告文章');
      article =
          await OaAnnouncementInit.bulletin.getBulletinDetail(widget.summary.bulletinCatalogueId, widget.summary.uuid);
      Log.info('加载OA公告文章完毕');
    } else {
      Log.info('使用已获取的OA公告文章');
    }

    return article!;
  }

  Widget _buildBody(BulletinRecord summary) {
    return MyFutureBuilder<BulletinDetail>(
      futureGetter: () => getBulletinDetail(),
      builder: (context, data) {
        return SingleChildScrollView(child: _buildArticle(context, data));
      },
      onErrorBuilder: (context, fb, error, stack) {
        return Text(error.runtimeType.toString());
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: i18n.oaAnnouncementTextTitle.txt,
        actions: [
          IconButton(
            onPressed: () {
              final url =
                  'https://myportal.sit.edu.cn/detach.portal?action=bulletinBrowser&.ia=false&.pmn=view&.pen=${widget.summary.bulletinCatalogueId}&bulletinId=${widget.summary.uuid}';
              launchUrlInBrowser(url);
            },
            icon: const Icon(Icons.open_in_browser),
          ),
        ],
      ),
      body: Padding(padding: const EdgeInsets.all(12), child: _buildBody(widget.summary)),
    );
  }
}
