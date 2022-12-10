import '../entity/credential.dart';

abstract class CredentialDao {
  OaUserCredential? oaCredential;
  DateTime? lastOaAuthTime;
  FreshmanCredential? freshmanCredential;
  DateTime? lastFreshmanAuthTime;
}

