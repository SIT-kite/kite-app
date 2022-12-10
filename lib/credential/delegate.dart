import 'package:kite/credential/dao/credential.dart';
import 'package:kite/events/bus.dart';
import 'package:kite/events/events.dart';

import 'entity/credential.dart';

class CredentialDelegate implements CredentialDao {
  final CredentialDao storage;

  CredentialDelegate(this.storage);

  @override
  OACredential? get oaCredential => storage.oaCredential;

  @override
  set oaCredential(OACredential? newV) {
    if (storage.oaCredential != newV) {
      storage.oaCredential = newV;
      if (newV != null) {
        storage.lastOaAuthTime = DateTime.now();
      }
      FireOn.global(CredentialChangeEvent());
    }
  }

  @override
  DateTime? get lastOaAuthTime => storage.lastOaAuthTime;

  @override
  set lastOaAuthTime(DateTime? newV) {
    storage.lastOaAuthTime = newV;
  }

  @override
  FreshmanCredential? get freshmanCredential => storage.freshmanCredential;

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
  DateTime? get lastFreshmanAuthTime => storage.lastFreshmanAuthTime;

  @override
  set lastFreshmanAuthTime(DateTime? newV) {
    storage.lastFreshmanAuthTime = newV;
  }
}
