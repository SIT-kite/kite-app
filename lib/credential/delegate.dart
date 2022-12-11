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
import 'package:kite/credential/dao/credential.dart';
import 'package:kite/credential/storage/credential.dart';
import 'package:kite/events/bus.dart';
import 'package:kite/events/events.dart';
import 'package:kite/module/shared/global.dart';

import 'entity/credential.dart';
import 'entity/user_type.dart';
import 'user_widget/scope.dart';
import 'utils.dart';

class CredentialDelegate implements CredentialDao {
  final CredentialStorage storage;

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
        lastUserType = guessUserTypeByAccount(newV.account);
      }
      FireOn.global(CredentialChangeEvent());
    }
  }

  @override
  DateTime? get lastOaAuthTime => Global.buildContext!.auth.lastOaAuthTime;

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

  set lastFreshmanAuthTime(DateTime? newV) {
    storage.lastFreshmanAuthTime = newV;
  }

  @override
  UserType? get lastUserType => Global.buildContext!.auth.lastUserType;

  set lastUserType(UserType? newV) {
    storage.lastUserType = newV;
  }
}
