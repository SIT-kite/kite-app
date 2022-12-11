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
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rettulf/rettulf.dart';
import '../using.dart';

import 'list.dart';
import 'mailbox.dart';

class ApplicationIndexPage extends StatefulWidget {
  const ApplicationIndexPage({super.key});

  @override
  State<ApplicationIndexPage> createState() => _ApplicationIndexPageState();
}

class _ApplicationIndexPageState extends State<ApplicationIndexPage> {
  final $enableFilter = ValueNotifier(false);

  @override
  Widget build(BuildContext context) {
    if (!Auth.hasLoggedIn) {
      return UnauthorizedTipPage(title: i18n.ftype_examArr.text());
    }
    return AdaptiveNavi(
      title: i18n.ftype_application,
      defaultIndex: 0,
      actions: [
        IconButton(
          icon: const Icon(CupertinoIcons.info_circle),
          onPressed: () async => showInfo(context),
        ),
        IconButton(
          icon: $enableFilter.value ? const Icon(Icons.filter_alt_outlined) : const Icon(Icons.filter_alt_off_outlined),
          tooltip: i18n.applicationFilerInfrequentlyUsed,
          onPressed: () {
            setState(() {
              $enableFilter.value = !$enableFilter.value;
            });
          },
        ),
      ],
      pages: [
        // Activity List page
        AdaptivePage(
          label: i18n.applicationAllNavigation,
          unselectedIcon: const Icon(Icons.check_box_outline_blank),
          selectedIcon: const Icon(Icons.list_alt_rounded),
          builder: (ctx, key) {
            return ApplicationList(key: key, $enableFilter: $enableFilter);
          },
        ),
        // Mine page
        AdaptivePage(
          label: i18n.applicationMailboxNavigation,
          unselectedIcon: const Icon(Icons.mail_outline_rounded),
          selectedIcon: const Icon(Icons.mail_rounded),
          builder: (ctx, key) {
            return Mailbox(key: key);
          },
        ),
      ],
    );
  }
}

Future<void> showInfo(BuildContext ctx) async {
  await ctx.showTip(title: i18n.ftype_application, desc: i18n.applicationDesc, ok: i18n.close);
}
