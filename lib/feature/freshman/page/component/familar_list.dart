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
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../entity.dart';
import 'card.dart';
import 'common.dart';
import 'profile.dart';
import 'package:kite/l10n/extension.dart';

class FamiliarListWidget extends StatefulWidget {
  final List<Familiar> familiarList;
  final VoidCallback? onRefresh;

  const FamiliarListWidget(this.familiarList, {this.onRefresh, Key? key}) : super(key: key);

  @override
  State<FamiliarListWidget> createState() => _FamiliarListWidgetState();
}

class _FamiliarListWidgetState extends State<FamiliarListWidget> {
  final RefreshController _refreshController = RefreshController();

  ///加载更多
  void loadMore(Familiar familiar) {
    final lastSeenText = calcLastSeen(familiar.lastSeen);

    Navigator.of(context).push(
      MaterialPageRoute(builder: (ctx) {
        return BasicInfoPageWidget(
          name: familiar.name,
          college: familiar.college,
          infoItems: [
            InfoItem(Icons.account_circle, i18n.fullName, familiar.name),
            InfoItem(Icons.school, i18n.faculty, familiar.college),
            InfoItem(familiar.gender == 'M' ? Icons.male : Icons.female, i18n.gender,
                familiar.gender == 'M' ? i18n.male : i18n.female),
            if (familiar.city != null) InfoItem(Icons.location_city, i18n.city, familiar.city!),
            if (familiar.lastSeen != null) InfoItem(Icons.timelapse, i18n.lastOnlineTime, lastSeenText),
            ...buildContactInfoItems(context, familiar.contact), // unpack
          ],
        );
      }),
    );
  }

  Widget buildBasicInfoWidget(Familiar familiar) {
    final wechat = familiar.contact?.wechat;
    final qq = familiar.contact?.qq;
    final tel = familiar.contact?.tel;
    final wechatRow = buildInfoItemRow(
      iconData: Icons.wechat,
      text: '${i18n.wechat}  ${wechat != null && wechat != '' ? wechat : i18n.unfilled}',
      context: context,
    );
    final qqRow = buildInfoItemRow(
      iconData: Icons.person,
      text: '${i18n.qq}:  ${qq != null && qq != '' ? qq : i18n.unfilled}',
      context: context,
    );
    final telRow = buildInfoItemRow(
      iconData: Icons.phone,
      text: '${i18n.tel}  ${tel != null && tel != '' ? tel : i18n.unfilled}',
      context: context,
    );

    return Stack(
      children: [
        Align(
          alignment: const Alignment(1.3, -1.5),
          child: SizedBox(
            width: 100,
            height: 100,
            child: buildSexIcon(familiar.gender == 'M'),
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              familiar.name,
              style: const TextStyle(fontSize: 35, color: Colors.black54, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 8.h,
            ),
            buildInfoItemRow(
              iconData: Icons.school,
              text: '${i18n.faculty}  ${familiar.college}',
              context: context,
            ),
            wechatRow,
            qqRow,
            telRow,
          ],
        ),
      ],
    );
  }

  /// 性别icon印章
  Widget buildSexIcon(bool isMale) {
    return Icon(
      isMale ? Icons.male : Icons.female,
      size: 50,
      color: isMale ? Colors.lightBlue : Colors.pinkAccent,
    );
  }

  Widget buildListView(List<Familiar> list) {
    return ListView(
      controller: ScrollController(),
      children: list.map((e) {
        return PersonItemWidget(
          basicInfoWidget: buildBasicInfoWidget(e),
          name: e.name,
          isMale: e.gender == 'M',
          lastSeenText: calcLastSeen(e.lastSeen),
          locationText: e.city,
          onLoadMore: () => loadMore(e),
          height: 220,
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildInfoItemRow(
          iconData: Icons.info,
          text: '${i18n.numberOfPeopleBesidesMe}: ${widget.familiarList.length}',
          context: context,
        ).withTitleBarStyle(context),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SmartRefresher(
              controller: _refreshController,
              onRefresh: widget.onRefresh,
              child: buildListView(widget.familiarList),
            ),
          ),
        ),
      ],
    );
  }
}
