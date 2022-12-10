/*
 * 上应小风筝  便利校园，一步到位
 * Copyright (C) 2022 上海应用技术大学 上应小风筝团队
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

import 'package:flutter/foundation.dart';

import 'using.dart';
import 'adapter.dart';

class HiveBoxInit {
  HiveBoxInit._();

  static late Box<dynamic> credential;
  static late Box<dynamic> userEvent;
  static late Box<LibrarySearchHistoryItem> librarySearchHistory;
  static late Box<ContactData> contactSetting;
  static late Box<dynamic> course;
  static late Box<dynamic> expense2;
  static late Box<dynamic> activityCache;
  static late Box<dynamic> examArrCache;
  static late Box<dynamic> oaAnnounceCache;
  static late Box<dynamic> applicationCache;
  static late Box<dynamic> game;
  static late Box<dynamic> kv;
  static late Box<dynamic> cookiesBox;

  static late Map<String, Box> name2Box;

  static Future<void> init(String root) async {
    await Hive.initFlutter(root);
    HiveAdapter.registerAll();
    credential = await Hive.openBox('credential');
    kv = await Hive.openBox('setting');
    userEvent = await Hive.openBox('userEvent');
    librarySearchHistory = await Hive.openBox('librarySearchHistory');
    contactSetting = await Hive.openBox('contactSetting');
    course = await Hive.openBox<dynamic>('course');
    expense2 = await Hive.openBox('expense2');
    activityCache = await Hive.openBox('activityCache');
    examArrCache = await Hive.openBox('examArrCache');
    oaAnnounceCache = await Hive.openBox('oaAnnounceCache');
    applicationCache = await Hive.openBox('applicationCache');
    game = await Hive.openBox<dynamic>('game');
    cookiesBox = await Hive.openBox<dynamic>('cookies');
    name2Box = {
      "credential": HiveBoxInit.credential,
      "setting": HiveBoxInit.kv,
      "librarySearchHistory": HiveBoxInit.librarySearchHistory,
      "cookies": HiveBoxInit.cookiesBox,
      "game": HiveBoxInit.game,
      "course": HiveBoxInit.course,
      if (kDebugMode) "userEvent": HiveBoxInit.userEvent,
      "examArrCache": HiveBoxInit.examArrCache,
      "oaAnnounceCache": HiveBoxInit.oaAnnounceCache,
      "activityCache": HiveBoxInit.activityCache,
      "applicationCache": HiveBoxInit.applicationCache,
      "contactSetting": HiveBoxInit.contactSetting,
      // almost time, this box is very very long which ends up low performance in building.
      // So put this on the bottom
      "expense2": HiveBoxInit.expense2,
    };
  }

  static Future<void> clear() async {
    await credential.deleteFromDisk();
    await kv.deleteFromDisk();
    await userEvent.deleteFromDisk();
    await librarySearchHistory.deleteFromDisk();
    await contactSetting.deleteFromDisk();
    await course.deleteFromDisk();
    await expense2.deleteFromDisk();
    await activityCache.deleteFromDisk();
    await examArrCache.deleteFromDisk();
    await oaAnnounceCache.deleteFromDisk();
    await applicationCache.deleteFromDisk();
    await game.deleteFromDisk();
    await cookiesBox.deleteFromDisk();
    await Hive.close();
  }

  static Future<void> clearCache() async {
    activityCache.clear();
    oaAnnounceCache.clear();
    examArrCache.clear();
    applicationCache.clear();
  }
}
