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

import 'package:hive_flutter/hive_flutter.dart';
import 'package:kite/module/library/search/entity/search_history.dart';
import 'package:kite/module/yellow_pages/entity/contact.dart';

import 'adapter.dart';

class HiveBoxInit {
  HiveBoxInit._();

  static late Box<dynamic> userEvent;
  static late Box<LibrarySearchHistoryItem> librarySearchHistory;
  static late Box<ContactData> contactSetting;
  static late Box<dynamic> course;
  static late Box<dynamic> expense2;
  static late Box<dynamic> activityCache;
  static late Box<dynamic> examArrCache;
  static late Box<dynamic> game;
  static late Box<dynamic> kv;
  static late Box<dynamic> cookiesBox;

  static late Map<String, Box> name2Box;

  static Future<void> init(String root) async {
    await Hive.initFlutter(root);
    HiveAdapter.registerAll();
    kv = await Hive.openBox('setting');
    userEvent = await Hive.openBox('userEvent');
    librarySearchHistory = await Hive.openBox('librarySearchHistory');
    contactSetting = await Hive.openBox('contactSetting');
    course = await Hive.openBox<dynamic>('course');
    expense2 = await Hive.openBox('expense2');
    activityCache = await Hive.openBox('activityCache');
    examArrCache = await Hive.openBox('examArrCache');
    game = await Hive.openBox<dynamic>('game');
    cookiesBox = await Hive.openBox<dynamic>('cookies');
    name2Box = {
      "setting": HiveBoxInit.kv,
      "librarySearchHistory": HiveBoxInit.librarySearchHistory,
      "cookies": HiveBoxInit.cookiesBox,
      "game": HiveBoxInit.game,
      "course": HiveBoxInit.course,
      "userEvent": HiveBoxInit.userEvent,
      "examArrCache": HiveBoxInit.examArrCache,
      "activityCache": HiveBoxInit.activityCache,
      "contactSetting": HiveBoxInit.contactSetting,
      "expense2": HiveBoxInit.expense2,
      // almost time, this box is very very long which ends up low performance in building.
      // So put this on the bottom
    };
  }

  static Future<void> clear() async {
    await Hive.deleteBoxFromDisk('contactSetting');
    await Hive.deleteBoxFromDisk('setting');
    await Hive.deleteBoxFromDisk('auth');
    await Hive.deleteBoxFromDisk('librarySearchHistory');
    await Hive.deleteBoxFromDisk('course');
    await Hive.deleteBoxFromDisk('expenseSetting');
    await Hive.deleteBoxFromDisk('expense2');
    await Hive.deleteBoxFromDisk('game');
    await Hive.deleteBoxFromDisk('mail');
    await Hive.deleteBoxFromDisk('cookies');
    await Hive.close();
  }
}
