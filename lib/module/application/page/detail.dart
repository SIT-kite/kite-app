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
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:kite/launcher.dart';
import 'package:kite/util/url_launcher.dart';
import 'package:rettulf/rettulf.dart';
import 'package:universal_platform/universal_platform.dart';
import '../entity/function.dart';

import '../init.dart';
import '../using.dart';
import '../page/browser.dart';

class DetailPage extends StatefulWidget {
  final ApplicationMeta meta;

  const DetailPage({super.key, required this.meta});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  ApplicationMeta get meta => widget.meta;
  ApplicationDetail? _detail;

  @override
  void initState() {
    super.initState();
    ApplicationInit.applicationService.getApplicationDetail(meta.id).then((value) {
      if (!mounted) return;
      setState(() {
        _detail = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return context.isPortrait ? buildPortrait(context) : buildLandscape(context);
  }

  Widget buildPortrait(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(meta.name)),
      body: SafeArea(
        child: buildBody(context),
      ),
      // floatingActionButton: buildOpenInAppFAB(), TODO: fix this
    );
  }

  Widget buildOpenInAppFAB() {
    return FloatingActionButton(
      child: const Icon(Icons.east),
      onPressed: () => openInApp(context),
    );
  }

  Widget buildLandscape(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(meta.name),
        /* actions: [
          buildOpenInApp(),
        ],*/
      ),
      body: SafeArea(
        child: buildBody(context),
      ),
    );
  }

  Widget buildOpenInApp() {
    return PlainExtendedButton(
      label: i18n.open.text(),
      icon: const Icon(Icons.open_in_browser),
      tap: () => openInApp(context),
    );
  }

  Widget buildBody(
    BuildContext context,
  ) {
    final detail = _detail;
    if (detail == null) {
      return Placeholders.loading();
    } else {
      final sections = detail.sections;
      return sections
          .map((e) => _buildSection(context, e))
          .toList()
          .column(
            caa: CrossAxisAlignment.start,
            mas: MainAxisSize.min,
          )
          .padAll(10)
          .scrolled();
    }
  }

  void openInApp(BuildContext ctx) {
    if (UniversalPlatform.isDesktopOrWeb) {
      GlobalLauncher.launch("http://ywb.sit.edu.cn/v1/#/");
    } else {
      // 跳转到申请页面
      final String applyUrl = 'https://xgfy.sit.edu.cn/unifri-flow/WF/MyFlow.htm?ismobile=1&out=1&FK_Flow=${meta.id}';
      ctx.navigator.pushReplacement(MaterialPageRoute(builder: (_) => InAppViewPage(title: meta.name, url: applyUrl)));
    }
  }
}

Widget _buildSection(BuildContext context, ApplicationDetailSection section) {
  final titleStyle = Theme.of(context).textTheme.headline2;
  final textStyle = Theme.of(context).textTheme.bodyText2;

  Widget buildHtmlSection(String content) {
    final html = content.replaceAll('../app/files/', 'https://xgfy.sit.edu.cn/app/files/');
    return HtmlWidget(html, textStyle: textStyle, onTapUrl: (url) {
      launchUrlInBrowser(url);
      return true;
    });
  }

  Widget buildJsonSection(String content) {
    final Map kvPairs = jsonDecode(content);
    List<Widget> items = [];
    kvPairs.forEach((key, value) => items.add(Text('$key: $value', style: textStyle)));

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: items);
  }

  Widget buildOtherSection(String type, String _) {
    return Text('未知类型: $type', style: textStyle);
  }

  late Widget bodyWidget;
  switch (section.type) {
    case 'html':
      bodyWidget = buildHtmlSection(section.content);
      break;
    case 'json':
      bodyWidget = buildJsonSection(section.content);
      break;
    default:
      bodyWidget = buildOtherSection(section.type, section.content);
      break;
  }

  return Padding(
    padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(section.section, style: titleStyle),
        bodyWidget,
      ],
    ),
  );
}
