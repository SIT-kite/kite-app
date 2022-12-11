/*
 *    上应小风筝(SIT-kite)  便利校园，一步到位
 *    Copyright (C) 2022 上海应用技术大学 上应小风筝团队
 *
 *    This program is free software: you can redistribute it and/or modify
 *    it under the terms of the GNU General Public License as published by
 *    the Free Software Foundation, either version 3 of the License, or
 *    (at your option) any later version.
 *
 *    This program is distributed in the hope that it will be useful,
 *    but WITHOUT ANY WARRANTY; without even the implied warranty of
 *    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *    GNU General Public License for more details.
 *
 *    You should have received a copy of the GNU General Public License
 *    along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/
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
  String toString() => 'account:"$account", password:"$password"';

  OACredential copyWith({
    String? account,
    String? password,
  }) =>
      OACredential(
        account ?? this.account,
        password ?? this.password,
      );

  @override
  bool operator ==(Object other) {
    return other is OACredential &&
        runtimeType == other.runtimeType &&
        account == other.account &&
        password == other.password;
  }

  @override
  int get hashCode => toString().hashCode;
}

@HiveType(typeId: HiveTypeId.freshmanCredential)
class FreshmanCredential {
  @HiveField(0)
  final String account;
  @HiveField(1)
  final String password;

  FreshmanCredential(this.account, this.password);

  @override
  String toString() => 'account:"$account", password:"$password"';

  FreshmanCredential copyWith({
    String? account,
    String? password,
  }) =>
      FreshmanCredential(
        account ?? this.account,
        password ?? this.password,
      );

  @override
  bool operator ==(Object other) {
    return other is FreshmanCredential &&
        runtimeType == other.runtimeType &&
        account == other.account &&
        password == other.password;
  }

  @override
  int get hashCode => toString().hashCode;
}
