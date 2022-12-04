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
import 'package:rettulf/rettulf.dart';

import '../entity/contact.dart';
import '../using.dart';
import '../init.dart';
import 'list.dart';
import 'search.dart';

class YellowPagesPage extends StatefulWidget {
  const YellowPagesPage({Key? key}) : super(key: key);

  @override
  State<YellowPagesPage> createState() => _YellowPagesPageState();
}

class _YellowPagesPageState extends State<YellowPagesPage> {
  List<ContactData>? _contacts;

  Future<List<ContactData>> _fetchContactList() async {
    final service = YellowPagesInit.contactRemoteDao;
    final contacts = await service.getAllContacts();

    YellowPagesInit.contactStorageDao.clear();
    YellowPagesInit.contactStorageDao.addAll(contacts);
    return contacts;
  }

  @override
  void initState() {
    super.initState();
    _contacts = YellowPagesInit.contactStorageDao.getAllContacts();
    _fetchContactList().then((value) {
      if (!mounted) return;
      setState(() {
        _contacts = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final contacts = _contacts;
    return Scaffold(
      appBar: AppBar(
        title: i18n.ftype_yellowPages.text(),
        actions: [
          if (contacts != null)
            IconButton(
                onPressed: () => showSearch(context: context, delegate: Search(contacts)),
                icon: const Icon(Icons.search)),
          _buildRefreshButton(),
        ],
      ),
      body: context.isPortrait ? buildBodyPortrait(context) : buildBodyLandscape(context),
    );
  }

  Widget buildBodyPortrait(BuildContext ctx) {
    final contacts = _contacts;
    if (contacts == null || contacts.isEmpty) {
      return Placeholders.loading();
    } else {
      return GroupedContactList(contacts);
    }
  }

  Widget buildBodyLandscape(BuildContext ctx) {
    final contacts = _contacts;
    if (contacts == null || contacts.isEmpty) {
      return Placeholders.loading();
    } else {
      return NavigationContactList(contacts);
    }
  }

  Widget _buildRefreshButton() {
    return IconButton(
      tooltip: i18n.refresh,
      icon: const Icon(Icons.refresh),
      onPressed: () {
        _fetchContactList().then((value) {
          if (!mounted) return;
          setState(() {
            _contacts = value;
          });
        });
      },
    );
  }
}
