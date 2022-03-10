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

import '../entity/contact.dart';
import '../init.dart';
import 'list.dart';
import 'search.dart';

class ContactPage extends StatefulWidget {
  const ContactPage({Key? key}) : super(key: key);

  @override
  _ContactPageState createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  final List<ContactData> _contactData = ContactInitializer.contactStorageDao.getAllContacts();

  Future<List<ContactData>> _fetchContactList() async {
    final service = ContactInitializer.contactRemoteDao;
    final contacts = await service.getAllContacts();

    ContactInitializer.contactStorageDao.clear();
    ContactInitializer.contactStorageDao.addAll(contacts);
    return contacts;
  }

  Widget _buildBody() {
    if (_contactData.isNotEmpty) {
      return ContactList(_contactData);
    }

    return FutureBuilder<List<ContactData>>(
      future: _fetchContactList(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          _contactData.addAll(snapshot.data!);
          return ContactList(_contactData);
        } else if (snapshot.hasError) {
          return Center(child: Text(snapshot.error.toString()));
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('常用电话'),
        actions: [
          IconButton(
              onPressed: () => showSearch(context: context, delegate: Search(_contactData)),
              icon: const Icon(Icons.search)),
          _buildRefreshButton(),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildRefreshButton() {
    return IconButton(
      tooltip: '刷新',
      icon: const Icon(Icons.refresh),
      onPressed: () {
        _contactData.clear();
        setState(() {});
      },
    );
  }
}
