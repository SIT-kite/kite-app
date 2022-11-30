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
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

import '../entity/detail.dart';
import '../init.dart';
import '../using.dart';
import '../user_widgets/card.dart';
import 'util.dart';

String _getActivityUrl(int activityId) {
  return 'http://sc.sit.edu.cn/public/activity/activityDetail.action?activityId=$activityId';
}

class DetailPage extends StatelessWidget {
  final int activityId;
  final bool hideApplyButton;

  const DetailPage(this.activityId, {this.hideApplyButton = false, Key? key}) : super(key: key);

  AppBar _buildAppBar() {
    return AppBar(
      title: i18n.activityDetails.txt,
      actions: [
        IconButton(
          icon: const Icon(Icons.open_in_browser),
          onPressed: () {
            launchUrlInBrowser(_getActivityUrl(activityId));
          },
        )
      ],
    );
  }

  Widget _buildBasicInfo(BuildContext context, ActivityDetail detail) {
    final valueStyle = Theme.of(context).textTheme.bodyText2;
    final keyStyle = valueStyle?.copyWith(fontWeight: FontWeight.bold);

    buildRow(String key, String value) => TableRow(
          children: [
            Text(key, style: keyStyle),
            Text(value, style: valueStyle),
          ],
        );

    final titleStyle = Theme.of(context).textTheme.headline2;
    final titleSections = extractTitle(detail.title);
    final title = titleSections.last;
    titleSections.removeLast();

    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: Text(title, style: titleStyle, softWrap: true),
          ),
          Table(
            columnWidths: const {
              0: FlexColumnWidth(1),
              1: FlexColumnWidth(3),
            },
            children: [
              buildRow(i18n.activityID, detail.id.toString()),
              buildRow(i18n.activityLocation, detail.place.toString()),
              buildRow(i18n.activityPrincipal, detail.principal.toString()),
              buildRow(i18n.activityOrganizer, detail.organizer.toString()),
              buildRow(i18n.activityUndertaker, detail.undertaker.toString()),
              buildRow(i18n.activityContactInfo, detail.contactInfo.toString()),
              buildRow(i18n.activityStartTime, detail.startTime.toString()),
              buildRow(i18n.activityDuration, detail.duration.toString()),
              buildRow(i18n.activityTags, titleSections.join('\n')),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(BuildContext context, ActivityDetail detail) {
    return Stack(
      children: [
        const AspectRatio(
          aspectRatio: 1.8,
          child: CardCoverBackground(),
        ),
        Padding(
          padding: const EdgeInsets.all(20),
          child: Card(margin: const EdgeInsets.all(8), child: _buildBasicInfo(context, detail)),
        )
      ],
    );
  }

  Widget _buildArticle(BuildContext context, String html) {
    final textStyle = Theme.of(context).textTheme.bodyText1;

    return Padding(
        padding: const EdgeInsets.all(20), child: HtmlWidget(html, isSelectable: true, textStyle: textStyle));
  }

  Widget _buildDetail(BuildContext context, ActivityDetail detail) {
    final List<Widget> items = [
      _buildInfoCard(context, detail),
      _buildArticle(context, detail.description ?? '暂无信息'),
      const SizedBox(height: 64),
    ];
    return SingleChildScrollView(
      child: Column(mainAxisSize: MainAxisSize.min, children: items),
    );
  }

  Widget _buildBody(BuildContext context) {
    return FutureBuilder<ActivityDetail>(
        future: ScInit.scActivityDetailService.getActivityDetail(activityId),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return _buildDetail(context, snapshot.data!);
          }
          return const Center(child: CircularProgressIndicator());
        });
  }

  // TODO: Redesign UI with Dialog
  Future<void> _sendRequest(BuildContext context, bool force) async {
    try {
      final response = await ScInit.scJoinActivityService.join(activityId, force);
      // TODO: Don't share BuildContext.
      showBasicFlash(context, Text(response));
    } catch (e) {
      showBasicFlash(context, Text('错误: ${e.runtimeType}'), duration: const Duration(seconds: 3));
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(context),
      floatingActionButton: !hideApplyButton
          ? InkWell(
              /*onDoubleTap: () {
                // 报名活动（强制模式）
                _sendRequest(context, true);
              },*/
              child: FloatingActionButton.extended(
                icon: const Icon(Icons.person_add),
                label: i18n.activityApplyBtn.txt,
                onPressed: () async {
                  // 常规模式报名活动
                  _sendRequest(context, false);
                },
              ),
            )
          : null,
    );
  }
}
