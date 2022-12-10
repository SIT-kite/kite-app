import '../entity/credential.dart';
import '../entity/user_type.dart';

abstract class CredentialDao {
  OACredential? oaCredential;
  DateTime? get lastOaAuthTime;
  FreshmanCredential? freshmanCredential;
  DateTime? get lastFreshmanAuthTime;
  UserType? get lastUserType;
}

