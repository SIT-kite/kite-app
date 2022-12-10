import 'package:kite/auth/entity/credential.dart';

abstract class CredentialDao {
  OaUserCredential? oaUser;
  DateTime? lastOaAuthTime;
  FreshmanCredential? freshman;
  DateTime? lastFreshmanAuthTime;
}

