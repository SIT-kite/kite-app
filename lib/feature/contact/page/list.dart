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
import 'package:flutter/services.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:kite/util/url_launcher.dart';

import '../entity/contact.dart';

class ContactList extends StatelessWidget {
  final List<ContactData> contacts;

  const ContactList(this.contacts, {Key? key}) : super(key: key);

  Widget _buildContactItem(BuildContext context, ContactData contact) {
    final avatarStyle = Theme.of(context).textTheme.bodyText2!.copyWith(color: Colors.grey[50]);

    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Theme.of(context).primaryColor,
        child: Container(
            child: (contact.name ?? '').isEmpty
                ? Center(child: Icon(Icons.account_circle, size: 40, color: Colors.grey[50]))
                : Text(contact.name![0], style: avatarStyle)),
        radius: 20,
      ),
      title: Text('${contact.description}'),
      subtitle: Text(('${contact.name ?? ' '} ' + contact.phone).trim()),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.content_copy),
            color: Theme.of(context).primaryColor,
            onPressed: () => Clipboard.setData(ClipboardData(text: contact.phone)),
          ),
          IconButton(
            icon: const Icon(Icons.phone),
            color: Theme.of(context).primaryColor,
            onPressed: () {
              final phone = contact.phone;
              launchInBrowser('tel:${(phone.length == 8 ? '021' : '') + phone}');
            },
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final titleStyle = Theme.of(context).textTheme.bodyText2;

    return GroupedListView<ContactData, int>(
      elements: contacts,
      groupBy: (element) => element.department.hashCode,
      useStickyGroupSeparators: true,
      order: GroupedListOrder.DESC,
      // 生成电话列表
      itemBuilder: _buildContactItem,
      groupHeaderBuilder: (ContactData c) => ListTile(title: Text(c.department, style: titleStyle)),
    );
  }
}
