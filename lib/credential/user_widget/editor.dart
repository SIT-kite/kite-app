import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kite/l10n/extension.dart';
import 'package:rettulf/rettulf.dart';

typedef CredentialCtor<T> = T Function(String account, String password);

class CredentialEditor<T> extends StatefulWidget {
  final String account;
  final String password;
  final String? title;
  final CredentialCtor<T> ctor;

  const CredentialEditor({
    super.key,
    required this.account,
    required this.password,
    required this.title,
    required this.ctor,
  });

  @override
  State<CredentialEditor> createState() => _CredentialEditorState();
}

class _CredentialEditorState extends State<CredentialEditor> {
  late TextEditingController $account;
  late TextEditingController $password;

  @override
  void initState() {
    super.initState();
    $account = TextEditingController(text: widget.account);
    $password = TextEditingController(text: widget.password);
  }

  @override
  void dispose() {
    super.dispose();
    $account.dispose();
    $password.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        scrollable: true,
        title: widget.title?.text(style: const TextStyle(fontWeight: FontWeight.bold)),
        content: [
          buildField("account", $account),
          buildField("password", $password),
        ].column(),
        actions: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
            CupertinoButton(
                onPressed: () {
                  context.navigator.pop(widget.ctor($account.text, $password.text));
                },
                child: i18n.submit.text(style: const TextStyle(color: Colors.redAccent))),
            CupertinoButton(
              onPressed: () {
                context.navigator.pop(widget.ctor(widget.account, widget.password));
              },
              child: i18n.cancel.text(),
            )
          ])
        ]);
  }

  Widget buildField(
    String fieldName,
    TextEditingController textEditingController,
  ) {
    return TextFormField(
      autofocus: true,
      controller: textEditingController,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        labelText: fieldName,
      ),
    );
  }
}
