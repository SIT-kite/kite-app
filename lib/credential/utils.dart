import 'dao/credential.dart';
import 'entity/user_type.dart';

extension CredentialEx on CredentialDao {
  bool get hasLoggedIn => lastOaAuthTime != null;

  bool get asFreshman => freshmanCredential != null;
}

final RegExp _reUndergraduateId = RegExp(r'^(\d{6}[YGHE\d]\d{3})$');
final RegExp _rePostgraduateId = RegExp(r'^(\d{2}6\d{6})$');
final RegExp _reTeacherId = RegExp(r'^(\d{4})$');

/// [oaAccount] can be a student ID or a work number.
UserType? guessUserTypeByAccount(String oaAccount) {
  if (oaAccount.length == 10 && _reUndergraduateId.hasMatch(oaAccount.toUpperCase())) {
    return UserType.undergraduate;
  } else if (oaAccount.length == 9 && _rePostgraduateId.hasMatch(oaAccount)) {
    return UserType.postgraduate;
  } else if (oaAccount.length == 4 && _reTeacherId.hasMatch(oaAccount)) {
    return UserType.teacher;
  }
  return null;
}
