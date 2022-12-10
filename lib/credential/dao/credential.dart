import '../entity/credential.dart';
import '../entity/user_type.dart';

abstract class CredentialDao {
  OACredential? oaCredential;
  DateTime? lastOaAuthTime;
  FreshmanCredential? freshmanCredential;
  DateTime? lastFreshmanAuthTime;
  /// TODO: User Type?
  //UserType? lastUserType;
}

