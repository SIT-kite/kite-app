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
import 'package:catcher/catcher.dart';
import 'package:flutter/material.dart';
import 'package:kite/events/bus.dart';
import 'package:kite/events/events.dart';
import 'package:kite/l10n/extension.dart';
import 'package:kite/module/symbol.dart';
import 'package:kite/route.dart';
import 'package:kite/util/logger.dart';

import '../user_widget/brick.dart';

class KiteBulletinItem extends StatefulWidget {
  const KiteBulletinItem({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _KiteBulletinItemState();
}

class _KiteBulletinItemState extends State<KiteBulletinItem> {
  String? content;

  @override
  void initState() {
    super.initState();
    On.home<HomeRefreshEvent>((event) {
      updateLatestBulletin();
    });
    updateLatestBulletin();
  }

  void updateLatestBulletin() async {
    final String? result = await _buildContent();
    if (!mounted) return;
    setState(() => content = result);
  }

  Future<String?> _buildContent() async {
    try {
      Log.info('获取公告');
      final meta = await KiteBulletinInit.cache.getBulletinMeta();
      return meta.headTitle;
    } catch (e, s) {
      Catcher.reportCheckedError(e, s);
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Brick(
      route: RouteTable.kiteBulletin,
      icon: SvgAssetIcon('assets/home/icon_notice.svg'),
      title: i18n.ftype_kiteBulletin,
      subtitle: content ?? i18n.ftype_kiteBulletin_desc,
    );
  }
}
