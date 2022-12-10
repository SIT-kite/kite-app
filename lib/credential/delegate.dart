import 'package:kite/credential/dao/credential.dart';
import 'package:kite/events/bus.dart';
import 'package:kite/events/events.dart';
import 'package:kite/module/shared/global.dart';

import 'entity/credential.dart';
import 'entity/user_type.dart';
import 'user_widget/scope.dart';

final RegExp _reUndergraduateId = RegExp(r'^(\d{6}[YGHE\d]\d{3})$');
final RegExp _rePostgraduateId = RegExp(r'^(\d{2}6\d{6})$');
final RegExp _reTeacherId = RegExp(r'^(\d{4})$');

class CredentialDelegate implements CredentialDao {
  final CredentialDao storage;

  CredentialDelegate(this.storage);

  /// [storage.oaCredential] does also work. But I prefer to use Inherited Widget.
  @override
  OACredential? get oaCredential => Global.buildContext!.auth.oaCredential;

  @override
  set oaCredential(OACredential? newV) {
    if (storage.oaCredential != newV) {
      storage.oaCredential = newV;
      if (newV != null) {
        storage.lastOaAuthTime = DateTime.now();
        lastUserType = _guessUserType();
      }
      FireOn.global(CredentialChangeEvent());
    }
  }

  @override
  DateTime? get lastOaAuthTime => Global.buildContext!.auth.lastOaAuthTime;

  @override
  set lastOaAuthTime(DateTime? newV) {
    storage.lastOaAuthTime = newV;
  }

  @override
  FreshmanCredential? get freshmanCredential => Global.buildContext!.auth.freshmanCredential;

  @override
  set freshmanCredential(FreshmanCredential? newV) {
    if (storage.freshmanCredential != newV) {
      storage.freshmanCredential = newV;
      if (newV != null) {
        storage.lastFreshmanAuthTime = DateTime.now();
      }
      FireOn.global(CredentialChangeEvent());
    }
  }

  @override
  DateTime? get lastFreshmanAuthTime => Global.buildContext!.auth.lastFreshmanAuthTime;

  @override
  set lastFreshmanAuthTime(DateTime? newV) {
    storage.lastFreshmanAuthTime = newV;
  }

  @override
  UserType2? get lastUserType => Global.buildContext!.auth.lastUserType;

  @override
  set lastUserType(UserType2? newV) {
    storage.lastUserType = newV;
  }

  UserType2 _guessUserType() {
    final oa = oaCredential;
    if (oa != null) {
      return _guessUserTypeByAccount(oa.account) ?? UserType2.offline;
    }
    return UserType2.offline;
  }

  /// [oaAccount] can be a student ID or an examinee number.
  static UserType2? _guessUserTypeByAccount(String oaAccount) {
    if (oaAccount.length == 10 && _reUndergraduateId.hasMatch(oaAccount.toUpperCase())) {
      return UserType2.undergraduate;
    } else if (oaAccount.length == 9 && _rePostgraduateId.hasMatch(oaAccount)) {
      return UserType2.postgraduate;
    } else if (oaAccount.length == 4 && _reTeacherId.hasMatch(oaAccount)) {
      return UserType2.teacher;
    }
    return null;
  }
}
