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
import 'package:hive/hive.dart';

import '../dao/credential.dart';
import '../entity/credential.dart';
import '../entity/user_type.dart';

class _Key {
  static const ns = "/credential";
  static const oa = "$ns/oa";
  static const freshman = "$ns/freshman";
  static const lastOaAuthTime = "$ns/lastOaAuthTime";
  static const lastFreshmanAuthTime = "$ns/lastFreshmanAuthTime";
  static const lastUserType = "$ns/lastUserType";
}

class CredentialStorage implements CredentialDao {
  final Box<dynamic> box;

  CredentialStorage(this.box);

  @override
  OACredential? get oaCredential => box.get(_Key.oa);

  @override
  set oaCredential(OACredential? newV) => box.put(_Key.oa, newV);

  @override
  DateTime? get lastOaAuthTime => box.get(_Key.lastOaAuthTime);

  set lastOaAuthTime(DateTime? newV) => box.put(_Key.lastOaAuthTime, newV);

  @override
  FreshmanCredential? get freshmanCredential => box.get(_Key.freshman);

  @override
  set freshmanCredential(FreshmanCredential? newV) => box.put(_Key.freshman, newV);

  @override
  DateTime? get lastFreshmanAuthTime => box.get(_Key.lastFreshmanAuthTime);

  set lastFreshmanAuthTime(DateTime? newV) => box.put(_Key.lastFreshmanAuthTime, newV);

  @override
  UserType? get lastUserType => box.get(_Key.lastUserType);

  set lastUserType(UserType? newV) => box.put(_Key.lastUserType, newV);
}
