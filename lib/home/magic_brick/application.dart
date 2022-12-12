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
import 'package:kite/credential/symbol.dart';
import 'package:kite/events/bus.dart';
import 'package:kite/events/events.dart';
import 'package:kite/module/application/init.dart';
import 'package:kite/l10n/extension.dart';
import 'package:kite/route.dart';
import 'package:kite/storage/init.dart';
import 'package:kite/util/logger.dart';
import '../user_widget/brick.dart';

class ApplicationItem extends StatefulWidget {
  const ApplicationItem({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ApplicationItemState();
}

class _ApplicationItemState extends State<ApplicationItem> {
  String? content;

  @override
  void initState() {
    super.initState();
    On.home<HomeRefreshEvent>((event) {
      final oaCredential = Auth.oaCredential;
      if (oaCredential != null) {
        onHomeRefresh(oaCredential);
      }
    });
  }

  void _tryUpdateContent(String? newContent) {
    if (newContent != null) {
      if (newContent.isEmpty || newContent.trim().isEmpty) {
        content = null;
      } else {
        content = newContent;
      }
    } else {
      content = null;
    }
  }

  void onHomeRefresh(OACredential oaCredential) async {
    if (!mounted) return;
    final result = await buildContent(oaCredential);
    if (result != null) {
      Kv.home.lastOfficeStatus = result;
      if(!mounted) return;
      setState(() => _tryUpdateContent(result));
    }
  }

  Future<String?> buildContent(OACredential oaCredential) async {
    if (!ApplicationInit.session.isLogin) {
      try {
        await ApplicationInit.session.login(
          username: oaCredential.account,
          password: oaCredential.password,
        );
      } catch (e) {
        Log.error(e);
        return null;
      }
    }
    format(s, x) => x > 0 ? '$s ($x)' : '';
    final totalMessage = await ApplicationInit.messageService.getMessageCount();
    if (totalMessage == null) return null;
    final draftBlock = format(i18n.draft, totalMessage.inDraft);
    final doingBlock = format(i18n.processing, totalMessage.inProgress);
    final completedBlock = format(i18n.done, totalMessage.completed);

    return '$draftBlock $doingBlock $completedBlock'.trim();
  }

  @override
  Widget build(BuildContext context) {
    // 如果是首屏加载, 从缓存读
    _tryUpdateContent(Kv.home.lastOfficeStatus);
    return Brick(
        route: RouteTable.application,
        icon: SvgAssetIcon('assets/home/icon_office.svg'),
        title: i18n.ftype_application,
        subtitle: content ?? i18n.ftype_application_desc);
  }
}
