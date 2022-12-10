import '../entity/credential.dart';

abstract class CredentialDao {
  OACredential? oaCredential;
  DateTime? lastOaAuthTime;
  FreshmanCredential? freshmanCredential;
  DateTime? lastFreshmanAuthTime;
}

