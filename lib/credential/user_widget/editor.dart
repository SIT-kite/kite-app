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
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kite/l10n/extension.dart';
import 'package:rettulf/rettulf.dart';

import '../using.dart';

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
    return $Dialog$(
      title: widget.title,
      make: (ctx) => [
        buildField("account", $account),
        buildField("password", $password),
      ].column(mas: MainAxisSize.min),
      primary: $Action$(
          text: i18n.submit,
          onPressed: () {
            context.navigator.pop(widget.ctor($account.text, $password.text));
          }),
      secondary: $Action$(
          text: i18n.cancel,
          onPressed: () {
            context.navigator.pop(widget.ctor(widget.account, widget.password));
          }),
    );
  }

  Widget buildField(
    String fieldName,
    TextEditingController textEditingController,
  ) {
    return $TextField$(
      controller: textEditingController,
      textInputAction: TextInputAction.next,
      labelText: fieldName,
    ).padV(1);
  }
}
