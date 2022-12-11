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
import '../symbol.dart';

import '../using.dart';

part 'user_type.g.dart';

/// Note: In the new UserType, freshman isn't a valid UserType.
/// If you want to determine whether the user is a freshman, please check [Auth.freshmanCredential].
///
/// Offline isn't not different from others.
/// Instead, you should check the credentials to determine whether the function is open for them.
@HiveType(typeId: HiveTypeId.userType)
enum UserType {
  /// 本、专科生（10位学号）
  @HiveField(0)
  undergraduate,

  /// 研究生（9位学号）
  @HiveField(1)
  postgraduate,

  /// 教师（4位工号）
  @HiveField(2)
  teacher,
}
