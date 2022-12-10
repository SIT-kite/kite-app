import 'package:kite/credential/entity/credential.dart';
import 'package:kite/design/user_widgets/editor.dart';

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
  }
}
