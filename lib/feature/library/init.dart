import 'package:dio/dio.dart';
import 'package:hive/hive.dart';
import 'package:kite/feature/library/appointment/init.dart';
import 'package:kite/session/kite_session.dart';

import 'search/entity/search_history.dart';
import 'search/init.dart';

class LibraryInitializer {
  static Future<void> init({
    required Dio dio,
    required Box<LibrarySearchHistoryItem> searchHistoryBox,
    required KiteSession kiteSession,
  }) async {
    await LibrarySearchInitializer.init(dio: dio, searchHistoryBox: searchHistoryBox);
    LibraryAppointmentInitializer.init(kiteSession: kiteSession);
  }
}
