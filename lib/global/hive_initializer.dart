import 'package:hive_flutter/hive_flutter.dart';
import 'package:kite/feature/contact/entity/contact.dart';
import 'package:kite/feature/expense/entity/expense.dart';
import 'package:kite/feature/initializer_index.dart';
import 'package:kite/feature/library/search/entity/search_history.dart';

class HiveBoxInitializer {
  static late Box<dynamic> userEvent;
  static late Box<LibrarySearchHistoryItem> librarySearchHistory;
  static late Box<dynamic> electricity;
  static late Box<ContactData> contactSetting;
  static late Box<dynamic> course;
  static late Box<ExpenseRecord> expense;
  static late Box<dynamic> game;
  static late Box<dynamic> setting;

  static Future<void> init(String root) async {
    await Hive.initFlutter(root);
    registerAdapters();
    setting = await Hive.openBox('setting');
    userEvent = await Hive.openBox('userEvent');
    librarySearchHistory = await Hive.openBox('librarySearchHistory');
    electricity = await Hive.openBox('electricity');
    contactSetting = await Hive.openBox('contactSetting');
    course = await Hive.openBox<dynamic>('course');
    expense = await Hive.openBox('expenseSetting');
    game = await Hive.openBox<dynamic>('game');
  }

  static Future<void> clear() async {
    await Hive.deleteBoxFromDisk('electricity');
    await Hive.deleteBoxFromDisk('contactSetting');
    await Hive.deleteBoxFromDisk('setting');
    await Hive.deleteBoxFromDisk('auth');
    await Hive.deleteBoxFromDisk('librarySearchHistory');
    await Hive.deleteBoxFromDisk('course');
    await Hive.deleteBoxFromDisk('expenseSetting');
    await Hive.deleteBoxFromDisk('game');
    await Hive.deleteBoxFromDisk('mail');
    await Hive.close();
  }
}
