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
import 'package:flutter_html/flutter_html.dart';
import 'package:kite/design/utils.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rettulf/rettulf.dart';

import '../entity/announce.dart';
import '../entity/attachment.dart';
import '../init.dart';
import '../using.dart';

class DetailPage extends StatefulWidget {
  final AnnounceRecord summary;

  const DetailPage(this.summary, {super.key});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  static final RegExp _phoneRegex = RegExp(r"(6087\d{4})");
  static final RegExp _mobileRegex = RegExp(r"(\d{12})");
  AnnounceDetail? _detail;

  AnnounceRecord get summary => widget.summary;
  late final url =
      'https://myportal.sit.edu.cn/detach.portal?action=bulletinBrowser&.ia=false&.pmn=view&.pen=${summary.bulletinCatalogueId}&bulletinId=${summary.uuid}';

  Future<AnnounceDetail?> fetchAnnounceDetail() async {
    return await OaAnnounceInit.service.getAnnounceDetail(widget.summary.bulletinCatalogueId, widget.summary.uuid);
  }

  @override
  void initState() {
    super.initState();
    fetchAnnounceDetail().then((value) {
      setState(() {
        _detail = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: i18n.oaAnnouncementTextTitle.text(),
        actions: [
          IconButton(
            onPressed: () {
              launchUrlInBrowser(url);
            },
            icon: const Icon(Icons.open_in_browser),
          ),
        ],
      ),
      body: buildBody(context).padAll(12),
    );
  }

  Widget buildBody(BuildContext ctx) {
    final theme = ctx.theme;
    final titleStyle = theme.textTheme.headline2;
    return [
      [
        summary.title.text(style: titleStyle),
        buildInfoCard(ctx),
      ].wrap().hero(summary.uuid),
      (_detail != null ? buildDetailArticle(ctx) : Placeholders.loading()).animatedSwitched(
        d: const Duration(milliseconds: 800),
      ),
    ].column().scrolled();
  }

  Widget buildInfoCard(BuildContext ctx) {
    final valueStyle = Theme.of(context).textTheme.bodyText2;
    final keyStyle = valueStyle?.copyWith(fontWeight: FontWeight.bold);

    TableRow buildRow(String key, String value) => TableRow(
          children: [
            Text(key, style: keyStyle),
            Text(value, style: valueStyle),
          ],
        );

    return Card(
      margin: const EdgeInsets.fromLTRB(2, 10, 2, 2),
      elevation: 3,
      child: Padding(
          padding: const EdgeInsets.all(10),
          child: Table(
            columnWidths: const {
              0: FlexColumnWidth(1),
              1: FlexColumnWidth(3),
            },
            children: [
              buildRow(i18n.publishingDepartment, summary.department),
              buildRow(i18n.author, _detail?.author ?? "..."),
              buildRow(i18n.publishTime, context.dateText(summary.dateTime)),
            ],
          )),
    );
  }

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

  Future<void> _onDownloadFile(AnnounceAttachment attachment) async {
    showBasicFlash(context, i18n.downloading.text());
    Log.info('下载文件: [${attachment.name}](${attachment.url})');

    String targetPath = '${(await getTemporaryDirectory()).path}/kite1/downloads/${attachment.name}';
    Log.info('下载到：$targetPath');
    // 如果文件不存在，那么下载文件
    if (!await File(targetPath).exists()) {
      await OaAnnounceInit.session.download(
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
                i18n.downloadCompleted.text(),
                Text(attachment.name),
              ],
            ),
          ),
          TextButton(
            onPressed: () => OpenFilex.open(targetPath),
            child: i18n.open.text(),
          ),
        ],
      ),
      duration: const Duration(seconds: 5),
    );
  }

  Widget buildDetailArticle(BuildContext ctx) {
    final detail = _detail;
    if (detail == null) {
      return const SizedBox();
    }
    final theme = context.theme;
    final titleStyle = theme.textTheme.headline2;
    final htmlContent = _linkTel(detail.content);
    return [
      // DarkModeSafe sometimes isn't safe.
      if (theme.isDark) DarkModeSafeHtmlWidget(htmlContent) else MyHtmlWidget(htmlContent),
      const SizedBox(height: 30),
      if (detail.attachments.isNotEmpty)
        Text(i18n.oaAnnouncementAttachmentTip(detail.attachments.length), style: titleStyle),
      if (detail.attachments.isNotEmpty)
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: detail.attachments.map((e) {
            return TextButton(
              onPressed: () async => _onDownloadFile(e),
              child: Text(e.name),
            );
          }).toList(),
        )
    ].column();
  }
}

class DarkModeSafeHtmlWidget extends StatefulWidget {
  final String html;

  const DarkModeSafeHtmlWidget(
    this.html, {
    super.key,
  });

  @override
  State<DarkModeSafeHtmlWidget> createState() => _DarkModeSafeHtmlWidgetState();
}

class _DarkModeSafeHtmlWidgetState extends State<DarkModeSafeHtmlWidget> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bgColor = theme.backgroundColor;
    final textColor = theme.textTheme.bodyText2?.color ?? Colors.white;
    final fontFamily = theme.textTheme.bodyText2?.fontFamily ?? "";
    final fontSizeNumber = theme.textTheme.bodyText2?.fontSize;
    final fontSize = fontSizeNumber != null ? FontSize(fontSizeNumber) : FontSize.large;
    return SingleChildScrollView(
        child: SelectableHtml(
            data: widget.html,
            onLinkTap: (url, context, attributes, element) async {
              if (url != null) {
                await GlobalLauncher.launch(url);
              }
            },
            style: {
              "p": Style(
                backgroundColor: bgColor,
                color: textColor,
                fontSize: fontSize,
                fontFamily: fontFamily,
              ),
              "div": Style(
                color: textColor,
                backgroundColor: bgColor,
                fontSize: fontSize,
                fontFamily: fontFamily,
              ),
              "span": Style(
                color: textColor,
                backgroundColor: bgColor,
                fontSize: fontSize,
                fontFamily: fontFamily,
              ),
              "b": Style(
                color: textColor,
                backgroundColor: bgColor,
                fontSize: fontSize,
                fontFamily: fontFamily,
              ),
            },
            tagsList: filterTags([...Html.tags])));
  }

  List<String> filterTags(List<String> tags) {
    return tags;
  }
}
