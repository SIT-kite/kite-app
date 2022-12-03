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
import 'package:grouped_list/grouped_list.dart';
import 'package:kite/design/colors.dart';
import '../user_widgets/contact.dart';

import '../entity/contact.dart';

class GroupedContactList extends StatelessWidget {
  final List<ContactData> contacts;

  const GroupedContactList(this.contacts, {super.key});

  @override
  Widget build(BuildContext context) {
    return GroupedListView<ContactData, int>(
      elements: contacts,
      groupBy: (element) => element.department.hashCode,
      useStickyGroupSeparators: true,
      stickyHeaderBackgroundColor: context.bgColor,
      order: GroupedListOrder.DESC,
      // 生成电话列表
      itemBuilder: (ctx, contact) => ContactTile(contact),
      groupHeaderBuilder: (ContactData c) => ListTile(
        title: Text(
          c.department,
          //style: titleStyle,
        ),
      ),
    );
  }
}
