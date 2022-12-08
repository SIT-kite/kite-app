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
import 'package:kite/global/global.dart';
import 'package:kite/module/freshman/using.dart';
import '../brick.dart';

class EduEmailItem extends StatefulWidget {
  const EduEmailItem({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _EduEmailItemState();
}

class _EduEmailItemState extends State<EduEmailItem> {
  String? content;

  @override
  void initState() {
    super.initState();
    Global.eventBus.on(EventNameConstants.onHomeRefresh, _onHomeRefresh);
  }

  @override
  void dispose() {
    Global.eventBus.off(EventNameConstants.onHomeRefresh, _onHomeRefresh);
    super.dispose();
  }

  void _onHomeRefresh(_) async {}

  @override
  Widget build(BuildContext context) {
    return Brick(
      route: RouteTable.eduEmail,
      icon: SvgAssetIcon('assets/home/icon_mail.svg'),
      title: i18n.ftype_eduEmail,
      subtitle: content ?? i18n.ftype_eduEmail_desc,
    );
  }
}
