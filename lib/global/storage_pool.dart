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
import 'package:kite/domain/contact/entity/contact.dart';
import 'package:kite/domain/edu/dao/timetable.dart';
import 'package:kite/domain/edu/entity/timetable.dart';
import 'package:kite/domain/edu/storage/timetable.dart';
import 'package:kite/domain/expense/entity/expense.dart';
import 'package:kite/domain/kite/dao/user_event.dart';
import 'package:kite/domain/kite/storage/user_event.dart';
import 'package:kite/domain/mail/dao/mail.dart';
import 'package:kite/domain/mail/storage/mail.dart';
import 'package:kite/util/hive_register_adapter.dart';
import 'package:kite/util/logger.dart';

/// 本地持久化层
class StoragePool {
  static late TimetableStorage _course;

  static TimetableStorageDao get timetable => _course;

  static late UserEventStorage _userEvent;

  static UserEventStorageDao get userEvent => _userEvent;

  static late MailStorage _mail;

  static MailStorageDao get mail => _mail;

  static Future<void> _registerAdapters() async {
    registerAdapter(CourseAdapter());
    registerAdapter(ExpenseRecordAdapter());
    registerAdapter(ExpenseTypeAdapter());
    registerAdapter(ContactDataAdapter());
  }

  static Future<void> init() async {
    Log.info("初始化StoragePool");
    await Hive.initFlutter('kite/hive');
    await _registerAdapters();

    final courseBox = await Hive.openBox<dynamic>('course');
    _course = TimetableStorage(courseBox);

    final userEventStorage = await Hive.openBox<dynamic>('userEvent');
    _userEvent = UserEventStorage(userEventStorage);

    final mailStorage = await Hive.openBox<dynamic>('mail');
    _mail = MailStorage(mailStorage);
  }

  static Future<void> clear() async {
    await Hive.close();
    await Hive.deleteBoxFromDisk('setting');
    await Hive.deleteBoxFromDisk('auth');
    await Hive.deleteBoxFromDisk('library.search_history');
    await Hive.deleteBoxFromDisk('course');
    await Hive.deleteBoxFromDisk('expense');
    await Hive.deleteBoxFromDisk('game');
    await Hive.deleteBoxFromDisk('mail');
  }
}
