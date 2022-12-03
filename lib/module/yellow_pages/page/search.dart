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
import '../page/list.dart';

class Search extends SearchDelegate<String> {
  final List<ContactData> contacts;

  Search(this.contacts) : super();

  @override
  List<Widget>? buildActions(BuildContext context) {
    return <Widget>[IconButton(onPressed: () => query = '', icon: const Icon(Icons.clear))];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return null;
  }

  @override
  Widget buildResults(BuildContext context) {
    final searched = contacts.where((e) => _search(query, e)).toList();
    return context.isPortrait ? GroupedContactList(searched) : NavigationContactList(searched);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isNotEmpty) {
      final searched = contacts.where((e) => _search(query, e)).toList();
      if (searched.isNotEmpty) {
        return context.isPortrait ? GroupedContactList(searched) : NavigationContactList(searched);
      }
    }
    return const SizedBox();
  }

  bool _search(String query, ContactData contactData) {
    query = query.toLowerCase();
    final name = contactData.name?.toLowerCase();
    final department = contactData.department.toLowerCase();
    final description = contactData.description?.toLowerCase();
    return department.contains(query) ||
        (name != null && name.contains(query)) ||
        (description != null && description.contains(query)) ||
        contactData.phone.contains(query);
  }
}
