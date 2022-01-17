import 'package:flutter/widgets.dart';
import 'package:kite/storage/auth.dart';
import 'package:kite/storage/search_history.dart';
import 'package:kite/util/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// 本地持久化层
class StoragePool {
  static late SharedPreferences _prefs;

  static late AuthStorage _auth;
  static AuthStorage get auth => _auth;

  static late SearchHistoryStorage _searchHistory;
  static SearchHistoryStorage get searchHistory => _searchHistory;

  static Future<void> init() async {
    // SP初始化之前必须确保这个执行
    WidgetsFlutterBinding.ensureInitialized();
    Log.info('WidgetsFlutterBinding.ensureInitialized');
    Log.info("初始化StoragePool");
    _prefs = await SharedPreferences.getInstance();
    _auth = AuthStorage(_prefs);
    _searchHistory = SearchHistoryStorage(_prefs);
  }
}
