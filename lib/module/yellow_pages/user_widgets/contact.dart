/*
 *    上应小风筝(SIT-kite)  便利校园，一步到位
 *    Copyright (C) 2022 上海应用技术大学 上应小风筝团队
 *
 *    This program is free software: you can redistribute it and/or modify
 *    it under the terms of the GNU General Public License as published by
 *    the Free Software Foundation, either version 3 of the License, or
 *    (at your option) any later version.
 *
 *    This program is distributed in the hope that it will be useful,
 *    but WITHOUT ANY WARRANTY; without even the implied warranty of
 *    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *    GNU General Public License for more details.
 *
 *    You should have received a copy of the GNU General Public License
 *    along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rettulf/rettulf.dart';

import '../entity/contact.dart';
import '../using.dart';

class ContactTile extends StatelessWidget {
  final ContactData contact;
  final Color? bgColor;

  const ContactTile(this.contact, {super.key, this.bgColor});

  @override
  Widget build(BuildContext context) {
    final avatarStyle = context.textTheme.bodyText2?.copyWith(color: Colors.grey[50]);
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Theme.of(context).primaryColor,
        radius: 20,
        child: Container(
            child: (contact.name ?? '').isEmpty
                ? Center(child: Icon(Icons.account_circle, size: 40, color: Colors.grey[50]))
                : Text(
                    contact.name![0],
                    style: avatarStyle,
                    overflow: TextOverflow.ellipsis,
                  )),
      ),
      title: contact.description.text(
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        ('${contact.name ?? ' '} ${contact.phone}').trim(),
        overflow: TextOverflow.ellipsis,
      ),
      tileColor: bgColor,
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.content_copy),
            onPressed: () => Clipboard.setData(ClipboardData(text: contact.phone)),
          ),
          IconButton(
            icon: const Icon(Icons.phone),
            onPressed: () {
              final phone = contact.phone;
              GlobalLauncher.launch('tel:${(phone.length == 8 ? '021' : '') + phone}');
            },
          )
        ],
      ),
    );
  }
}
