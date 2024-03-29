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
import 'package:kite/credential/entity/credential.dart';
import 'package:kite/design/user_widgets/editor.dart';

import 'entity/user_type.dart';
import 'storage/credential.dart';
import 'user_widget/editor.dart';
import 'using.dart';

class CredentialInit {
  static late CredentialStorage credential;

  static void init({
    required Box<dynamic> box,
  }) {
    credential = CredentialStorage(box);
    Editor.registerEditor<OACredential>((ctx, desc, initial) => CredentialEditor(
          account: initial.account,
          password: initial.password,
          title: desc,
          ctor: (account, password) => OACredential(account, password),
        ));
    Editor.registerEditor<FreshmanCredential>((ctx, desc, initial) => CredentialEditor(
          account: initial.account,
          password: initial.password,
          title: desc,
          ctor: (account, password) => FreshmanCredential(account, password),
        ));
    EditorEx.registerEnumEditor(UserType.values);
  }
}
