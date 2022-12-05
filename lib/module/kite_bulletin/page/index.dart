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

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:rettulf/rettulf.dart';

import '../entity/bulletin.dart';
import '../init.dart';
import '../user_widget/bulletin.dart';
import '../using.dart';

class KiteBulletinPage extends StatefulWidget {
  const KiteBulletinPage({super.key});

  @override
  State<StatefulWidget> createState() => _KiteBulletinPageState();
}

class _KiteBulletinPageState extends State<KiteBulletinPage> {
  List<KiteBulletin>? _bulletins;
  int? _selected;

  @override
  void initState() {
    super.initState();
    KiteBulletinInit.noticeService.getSortedBulletinList().then((value) {
      setState(() {
        _bulletins = value;
        if (value.isNotEmpty) {
          _selected ??= 0;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: i18n.ftype_kiteBulletin.text()),
      body: context.isPortrait ? buildBodyPortrait(context) : buildBodyLandscape(context),
    );
  }

  Widget buildBodyPortrait(BuildContext context) {
    return buildBulletinList(context);
  }

  Widget buildBodyLandscape(BuildContext ctx) {
    return [
      buildPreviewList(ctx).flexible(flex: 2),
      buildSelectedBulletinDetailArea(ctx).scrolled().align(at: Alignment.topCenter).flexible(flex: 4),
    ].row();
  }

  Widget buildSelectedBulletinDetailArea(BuildContext ctx) {
    final all = _bulletins;
    if (all == null) {
      return Placeholders.loading();
    } else {
      return buildSelectedBulletinDetail(ctx, all);
    }
  }

  Widget buildSelectedBulletinDetail(BuildContext ctx, List<KiteBulletin> all) {
    var selected = _selected;
    if (selected == null) {
      if (all.isNotEmpty) {
        selected = 0;
      } else {
        return LeavingBlank(icon: Icons.inbox_outlined, desc: i18n.emptyContent);
      }
    }
    var target = all[selected];
    return BulletinCard(key: ValueKey(target.id), target);
  }

  Widget buildPreviewList(BuildContext ctx) {
    final all = _bulletins;
    if (all == null) {
      return Placeholders.loading();
    } else {
      final list = all
          .mapIndexed((i, e) => BulletinPreview(
                e,
                isSelected: _selected == i,
              ).onTap(() {
                if (_selected != i) {
                  setState(() => _selected = i);
                }
              }))
          .toList();
      return list.scrolledWithBar();
    }
  }

  Widget buildBulletinList(BuildContext ctx) {
    final all = _bulletins;
    if (all == null) {
      return Placeholders.loading();
    } else {
      return all.map((e) => BulletinCard(e)).toList().column().scrolled();
    }
  }
}
