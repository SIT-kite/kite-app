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
import 'package:kite/user_widget/future_builder.dart';
import 'package:kite/util/url_launcher.dart';
import 'package:universal_platform/universal_platform.dart';
import '../entity/function.dart';

import '../init.dart';
import '../page/browser.dart';

class DetailPage extends StatelessWidget {
  final ApplicationMeta function;

  const DetailPage(this.function, {Key? key}) : super(key: key);

  Widget buildSection(BuildContext context, ApplicationDetailSection section) {
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

  Widget buildBody(BuildContext context, List<ApplicationDetailSection> sections) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: sections.map((e) => buildSection(context, e)).toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(function.name)),
      body: SafeArea(
        child: MyFutureBuilder<ApplicationDetail>(
          future: ApplicationInit.applicationService.getApplicationDetail(function.id),
          builder: (context, data) {
            return buildBody(context, data.sections);
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.east),
        onPressed: () {
          if (UniversalPlatform.isDesktopOrWeb) {
            GlobalLauncher.launch("http://ywb.sit.edu.cn/v1/#/");
          } else {
            // 跳转到申请页面
            final String applyUrl =
                'https://xgfy.sit.edu.cn/unifri-flow/WF/MyFlow.htm?ismobile=1&out=1&FK_Flow=${function.id}';
            Navigator.of(context)
                .pushReplacement(MaterialPageRoute(builder: (_) => InAppViewPage(title: function.name, url: applyUrl)));
          }
        },
      ),
    );
  }
}
