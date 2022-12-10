import '../using.dart';

part 'credential.g.dart';

@HiveType(typeId: HiveTypeId.oaUserCredential)
class OACredential {
  @HiveField(0)
  final String account;
  @HiveField(1)
  final String password;

  OACredential(this.account, this.password);

  @override
  String toString() => '{"account"="$account","password":"$password"}';

  OACredential copyWith({
    String? account,
    String? password,
  }) =>
      OACredential(
        account ?? this.account,
        password ?? this.password,
      );
}

@HiveType(typeId: HiveTypeId.freshmanCredential)
class FreshmanCredential {
  @HiveField(0)
  final String account;
  @HiveField(1)
  final String password;

  FreshmanCredential(this.account, this.password);

  @override
  String toString() => '{"account"="$account","password":"$password"}';

  FreshmanCredential copyWith({
    String? account,
    String? password,
  }) =>
      FreshmanCredential(
        account ?? this.account,
        password ?? this.password,
      );
}
