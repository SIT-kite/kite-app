import 'delegate.dart';

import 'dao/credential.dart';
import 'init.dart';

export 'entity/credential.dart';

// ignore: non_constant_identifier_names
CredentialDao get Auth => CredentialDelegate(CredentialInit.credential);
