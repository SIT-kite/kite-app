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
