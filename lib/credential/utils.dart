import 'dao/credential.dart';

extension CredentialEx on CredentialDao {
  bool get hasLoggedIn => lastOaAuthTime != null;

  bool get asFreshman => freshmanCredential != null;
}
