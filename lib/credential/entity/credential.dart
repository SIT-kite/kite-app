import '../using.dart';
@HiveType(typeId: HiveTypeId.oaUserCredential)
class OACredential {
  @HiveField(0)
  final String account;
  @HiveField(1)
  final String password;

  OACredential(this.account, this.password);
}

@HiveType(typeId: HiveTypeId.freshmanCredential)
class FreshmanCredential {
  @HiveField(0)
  final String account;
  @HiveField(1)
  final String password;

  FreshmanCredential(this.account, this.password);
}
