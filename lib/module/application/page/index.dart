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
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rettulf/rettulf.dart';
import '../using.dart';

import 'list.dart';
import 'mailbox.dart';

class ApplicationPage extends StatefulWidget {
  const ApplicationPage({Key? key}) : super(key: key);

  @override
  State<ApplicationPage> createState() => _ApplicationPageState();
}

class _Page {
  static const list = 0;
  static const mailbox = 1;
}

class _ApplicationPageState extends State<ApplicationPage> {
  int curNavigation = _Page.list;
  final pages = <Widget>[];
  final _pageListKey = GlobalKey();
  final _pageMineKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    pages.add(ApplicationList(
      key: _pageListKey,
    ));
    pages.add(Mailbox(
      key: _pageMineKey,
    ));
  }

  @override
  Widget build(BuildContext context) {
    if (!Auth.hasLoggedIn) {
      return UnauthorizedTipPage(title: i18n.ftype_examArr.text());
    } else {
      return context.isPortrait ? buildPortrait(context) : buildLandscape(context);
    }
  }

  Widget buildPortrait(BuildContext context) {
    return Scaffold(
      key: const ValueKey("Portrait"),
      appBar: AppBar(
        title: i18n.ftype_application.text(),
        actions: [
          IconButton(
            icon: const Icon(CupertinoIcons.info_circle),
            onPressed: () async => showInfo(context),
          )
        ],
      ),
      body: IndexedStack(
        index: curNavigation,
        children: pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            label: i18n.activityAllNavigation,
            icon: const Icon(Icons.description_outlined),
          ),
          BottomNavigationBarItem(
            label: i18n.applicationMailboxNavigation,
            icon: const Icon(Icons.mail_outline_outlined),
          )
        ],
        currentIndex: curNavigation,
        onTap: (int index) {
          setState(() => curNavigation = index);
        },
      ),
    );
  }

  Widget buildLandscape(BuildContext context) {
    return Scaffold(
      key: const ValueKey("Landscape"),
      body: Row(
        children: <Widget>[
          NavigationRail(
            leading: [
              IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () {
                    context.navigator.pop();
                  }),
              SizedBox(
                height: 5.h,
              ),
              IconButton(
                icon: const Icon(CupertinoIcons.info_circle),
                onPressed: () async => showInfo(context),
              )
            ].column(),
            selectedIndex: curNavigation,
            groupAlignment: 1.0,
            onDestinationSelected: (int index) {
              setState(() {
                curNavigation = index;
              });
            },
            labelType: NavigationRailLabelType.all,
            destinations: <NavigationRailDestination>[
              NavigationRailDestination(
                icon: const Icon(Icons.check_box_outline_blank),
                selectedIcon: const Icon(Icons.list_alt_rounded),
                label: i18n.applicationAllNavigation.text(),
              ),
              NavigationRailDestination(
                icon: const Icon(Icons.mail_outline_outlined),
                selectedIcon: const Icon(Icons.mail_rounded),
                label: i18n.applicationMailboxNavigation.text(),
              ),
            ],
          ),
          const VerticalDivider(thickness: 1, width: 1),
          // This is the main content.
          IndexedStack(
            index: curNavigation,
            children: pages,
          ).expanded()
        ],
      ),
    );
  }

/*
  PopupMenuButton _buildMenuButton(BuildContext context) {
    final menuButton = PopupMenuButton(
      itemBuilder: (BuildContext context) {
        return [
          PopupMenuItem(
            onTap: () {
              setState(() {
                enableFilter = !enableFilter;
              });
            },
            child: Row(
              children: [
                // 禁用checkbox自身的点击效果，点击由外部接管
                AbsorbPointer(
                  child: Checkbox(value: enableFilter, onChanged: (bool? value) {}),
                ),
                i18n.applicationFilerInfrequentlyUsed.text(),
              ],
            ),
          ),
        ];
      },
    );
    return menuButton;
  }*/
}

Future<void> showInfo(BuildContext ctx) async {
  await ctx.showTip(title: i18n.ftype_application, desc: i18n.applicationDesc, ok: i18n.close);
}
