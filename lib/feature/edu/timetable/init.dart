import 'package:hive/hive.dart';
import 'package:kite/abstract/abstract_session.dart';

import 'dao/timetable.dart';
import 'service/timetable.dart';
import 'storage/timetable.dart';

class TimetableInitializer {
  static late TimetableDao timetableService;
  static late TimetableStorageDao timetableStorage;

  static void init({
    required ASession eduSession,
    required Box<dynamic> timetableBox,
  }) {
    timetableService = TimetableService(eduSession);
    timetableStorage = TimetableStorage(timetableBox);
  }
}
