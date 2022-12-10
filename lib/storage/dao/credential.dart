import 'package:kite/auth/credential.dart';

abstract class CredentialDao {
  OaUserCredential? oaUser;
  DateTime? lastOaAuthTime;
  FreshmanCredential? freshman;
  DateTime? lastFreshmanAuthTime;
}

