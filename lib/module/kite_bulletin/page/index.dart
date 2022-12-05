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
import 'package:kite/user_widget/markdown_widget.dart';
import 'package:rettulf/rettulf.dart';

import '../entity/bulletin.dart';
import '../init.dart';
import '../using.dart';

class KiteBulletinPage extends StatefulWidget {
  const KiteBulletinPage({super.key});

  @override
  State<StatefulWidget> createState() => _KiteBulletinPageState();
}

class _KiteBulletinPageState extends State<KiteBulletinPage> {
  List<KiteBulletin>? _bulletins;

  @override
  void initState() {
    super.initState();
    KiteBulletinInit.noticeService.getNoticeList().then((value) {
      setState(() {
        _bulletins = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: i18n.ftype_kiteBulletin.text()),
      body: SafeArea(child: buildList(context)),
    );
  }

  Widget buildLandscape(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: i18n.ftype_kiteBulletin.text()),
      body: SafeArea(child: buildList(context)),
    );
  }

  Widget buildPortrait(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: i18n.ftype_kiteBulletin.text()),
      body: SafeArea(child: buildList(context)),
    );
  }

  _buildTitleText(BuildContext ctx, String title) {
    return Text(title, overflow: TextOverflow.ellipsis, style: Theme.of(ctx).textTheme.headline3);
  }

  _buildBulletinTitle(BuildContext ctx, KiteBulletin notice) {
    if (notice.top) {
      return Row(
        children: [const Icon(Icons.push_pin_rounded), _buildTitleText(ctx, notice.title)],
      );
    } else {
      return _buildTitleText(ctx, notice.title);
    }
  }

  Widget buildList(BuildContext context) {
    final list = _bulletins;
    if (list == null) {
      return Placeholders.loading();
    } else {
      return _buildBulletinList(context, list);
    }
  }

  Widget _buildBulletinList(BuildContext context, List<KiteBulletin> list) {
    return SingleChildScrollView(
      child: Column(
        children:
            list.map((e) => _buildBulletin(context, e).inCard(elevation: 5).padSymmetric(h: 10.h, v: 2.h)).toList(),
      ),
    );
  }

  Widget _buildBulletin(BuildContext context, KiteBulletin bulletin) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // 标题, 注意遇到长标题时要折断
              Expanded(
                child: _buildBulletinTitle(context, bulletin),
              ),
              // 日期
              Text(context.dateNum(bulletin.publishTime), style: const TextStyle(color: Colors.grey)),
            ],
          ),
          const SizedBox(height: 10),
          // 正文
          MyMarkdownWidget(bulletin.content ?? ''),
        ],
      ),
    );
  }
}
