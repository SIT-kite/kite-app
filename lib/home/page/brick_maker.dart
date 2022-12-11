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
import 'package:kite/credential/symbol.dart';

import '../entity/home.dart';

class BrickMaker {
  BrickMaker._();

  static final Map<int, List<FType>> _cache = {};

  static List<FType> makeDefaultBricks() {
    final oa = Auth.oaCredential;
    final freshman = Auth.freshmanCredential;
    final userType = Auth.lastUserType;
    final hasLoggedIn = Auth.hasLoggedIn;
    final key = oa.hashCode + freshman.hashCode + userType.hashCode + hasLoggedIn.hashCode;
    final cache = _cache[key];
    if (cache != null) {
      return cache;
    } else {
      final res = makeDefaultBricksBy(
        oa,
        freshman,
        userType,
        hasLoggedIn,
      );
      _cache[key] = res;
      return res;
    }
  }

  // TODO: A new personalization system for this.
  static List<FType> makeDefaultBricksBy(
    OACredential? oa,
    FreshmanCredential? freshman,
    UserType? userType,
    bool hasLoggedIn,
  ) {
    final r = <FType>[];
    // The common function for all users no matter user type.
    r << FType.upgrade;
    r << FType.kiteBulletin;
    if (hasLoggedIn && userType == UserType.undergraduate) {
      // Only undergraduates need the Timetable.
      // Open the timetable for anyone who has logged in before, even though they have a wrong credential now.
      r << FType.timetable;
    }
    if (oa != null) {
      // Only the OA user can report temperature.
      r << FType.reportTemp;
    }
    if (freshman != null) {
      r << FType.freshman;
    }
    if (oa == null) {
      // If OA credential is none, user can switch account.
      r << FType.switchAccount;
    }

    r << FType.separator;
    if (hasLoggedIn) {
      r << FType.expense;
      r << FType.electricityBill;
      if (userType == UserType.undergraduate) {
        // Only undergraduates need to check the activity, because it's linked to their Second class Score.
        r << FType.activity;
        r << FType.examResult;
        r << FType.examArr;
      }
      if (userType == UserType.undergraduate || userType == UserType.postgraduate) {
        r << FType.classroomBrowser;
      }
      r << FType.separator;
      // Only OA user can see the announcement.
      r << FType.oaAnnouncement;
    }
    if (hasLoggedIn) {
      r << FType.eduEmail;
      r << FType.application;
    }
    if (freshman == null && userType == UserType.undergraduate) {
      // If undergraduates doesn't login freshman, open the entry for them.
      r << FType.freshman;
    }
    // Everyone can use the library, but some functions only work for OA users.
    r << FType.library;
    // Yellow pages are open for all no matter user type.
    // Freshman or Offline may need to look up the tel.
    r << FType.yellowPages;
    r << FType.scanner;
    r << FType.separator;
    // Entertainment
    r << FType.game;
    r << FType.kiteBoard;
    r << FType.bbs;
    r << FType.wiki;
    // Trailing separator to ensure override works fine.
    r << FType.separator;
    return r;
  }
}

extension _ListEx<T> on List<T> {
  void operator <<(T e) => add(e);
}
