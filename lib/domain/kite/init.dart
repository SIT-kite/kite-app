import 'package:dio/dio.dart';
import 'package:hive/hive.dart';
import 'package:kite/abstract/abstract_session.dart';
import 'package:kite/domain/kite/service/classroom.dart';
import 'package:kite/domain/kite/service/index.dart';
import 'package:kite/domain/kite/storage/electricity.dart';

import 'dao/index.dart';

class KiteInitializer {
  static late ElectricityStorageDao electricityStorage;
  static late WeatherDao weatherService;

  static late ClassroomRemoteDao classroomService;
  static late ElectricityServiceDao electricityService;
  static late NoticeServiceDao noticeService;

  static late ASession kiteSession;
  static Future<void> init({
    required Dio dio,
    required ASession kiteSession,
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
