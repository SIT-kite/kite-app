import 'package:hive/hive.dart';
import '../entity/credential.dart';

import '../dao/credential.dart';

class _Key {
  static const ns = "/credentials";
  static const oa = "$ns/oa";
  static const freshman = "$ns/freshman";
  static const lastOaAuthTime = "$ns/lastOaAuthTime";
  static const lastFreshmanAuthTime = "$ns/lastFreshmanAuthTime";
}

class CredentialStorage implements CredentialDao {
  final Box<dynamic> box;

  CredentialStorage(this.box);

  @override
  OaUserCredential? get oaUser => box.get(_Key.oa);

  @override
  set oaUser(OaUserCredential? newV) => box.put(_Key.oa, newV);

  @override
  DateTime? get lastOaAuthTime => box.get(_Key.lastOaAuthTime);

  @override
  set lastOaAuthTime(DateTime? newV) => box.put(_Key.lastOaAuthTime, newV);

  @override
  FreshmanCredential? get freshman => box.get(_Key.freshman);

  @override
  set freshman(FreshmanCredential? newV) => box.put(_Key.freshman, newV);

  @override
  DateTime? get lastFreshmanAuthTime => box.get(_Key.lastFreshmanAuthTime);

  @override
  set lastFreshmanAuthTime(DateTime? newV) => box.put(_Key.lastFreshmanAuthTime, newV);
}
