import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rettulf/rettulf.dart';

import '../entity/contact.dart';
import '../using.dart';

class ContactTile extends StatelessWidget {
  final ContactData contact;

  const ContactTile(this.contact,{super.key});

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
                : Text(contact.name![0], style: avatarStyle)),
      ),
      title: Text('${contact.description}'),
      subtitle: Text(('${contact.name ?? ' '} ${contact.phone}').trim()),
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
              GlobalLauncher.launch('tel:${(phone.length == 8 ? '021' : '') + phone}');
            },
          )
        ],
      ),
    );
  }
}
