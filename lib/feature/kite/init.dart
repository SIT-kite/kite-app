import 'package:hive/hive.dart';
import 'package:kite/session/kite_session.dart';

import 'dao/index.dart';
import 'service/classroom.dart';
import 'service/index.dart';
import 'storage/electricity.dart';

class KiteInitializer {
  static late ElectricityStorageDao electricityStorage;
  static late WeatherDao weatherService;

  static late ClassroomRemoteDao classroomService;
  static late ElectricityServiceDao electricityService;
  static late NoticeServiceDao noticeService;

  static late KiteSession kiteSession;
  static Future<void> init({
    required KiteSession kiteSession,
    required Box<dynamic> electricityBox,
  }) async {
    KiteInitializer.kiteSession = kiteSession;
    classroomService = ClassroomService(kiteSession);
    electricityService = ElectricityService(kiteSession);
    noticeService = NoticeService(kiteSession);

    electricityStorage = ElectricityStorage(electricityBox);
    weatherService = WeatherService();
  }
}
